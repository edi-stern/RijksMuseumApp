//
//  ArtObjectsServiceTests.swift
//  Rijks MuseumTests
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import XCTest
import Combine
@testable import Rijks_Museum

class ArtObjectsServiceTests: XCTestCase {
	
	var service: ArtObjectsService!
	var mockNetworkService: MockNetworkService!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		mockNetworkService = MockNetworkService()
		service = ArtObjectsService(networkService: mockNetworkService)
	}
	
	override func tearDownWithError() throws {
		service = nil
		mockNetworkService = nil
		try super.tearDownWithError()
	}
	
	func testFetchArtObjectsSuccess() throws {
		// Given
		let expectation = expectation(
			description: "Art objects fetched successfully"
		)
		let mockResponse = MuseumData(
			artObjects: [
				ArtObject.mock(
					id: "1"
				),
				ArtObject.mock(
					id: "2"
				)
			]
		)
		mockNetworkService.result = .success(mockResponse)
		
		// When
		var receivedArtObjects: [ArtObject]?
		let cancellable = service.fetchArtObjects(page: 1)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case .failure(let error):
					XCTFail("Received error: \(error.localizedDescription)")
				}
			}, receiveValue: { artObjects in
				receivedArtObjects = artObjects
				expectation.fulfill()
			})
		
		// Then
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(receivedArtObjects)
		XCTAssertEqual(receivedArtObjects?.count, 2)
		XCTAssertEqual(receivedArtObjects?[0].id, "1")
		XCTAssertEqual(receivedArtObjects?[1].id, "2")
		cancellable.cancel()
	}
	
	func testFetchArtObjectsFailure() throws {
		// Given
		let expectation = expectation(
			description: "Art objects fetching failed"
		)
		let mockError = NSError(
			domain: "TestError",
			code: 123,
			userInfo: nil
		)
		mockNetworkService.result = .failure(mockError)
		
		// When
		var receivedError: Error?
		let cancellable = service.fetchArtObjects(page: 1)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case .failure(let error):
					receivedError = error
					expectation.fulfill()
				}
			}, receiveValue: { _ in })
		
		// Then
		waitForExpectations(
			timeout: 1,
			handler: nil
		)
		XCTAssertNotNil(receivedError)
		cancellable.cancel()
	}
}

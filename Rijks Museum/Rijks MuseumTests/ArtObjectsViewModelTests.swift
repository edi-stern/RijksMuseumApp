//
//  ArtObjectsViewModelTests.swift
//  Rijks MuseumTests
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import XCTest
import Combine
@testable import Rijks_Museum

class ArtObjectsViewModelTests: XCTestCase {

	var viewModel: ArtObjectsViewModel!
	var mockService: MockArtObjectsService!

	override func setUpWithError() throws {
		try super.setUpWithError()
		mockService = MockArtObjectsService()
		viewModel = ArtObjectsViewModel(artObjectsService: mockService)
	}

	override func tearDownWithError() throws {
		viewModel = nil
		mockService = nil
		try super.tearDownWithError()
	}

	func testFetchArtObjectsSuccessSameArtist() throws {
		// Given
		let expectation = expectation(description: "Art objects fetched successfully")
		let artObjects: [ArtObject] = [.mock(), .mock(id: "2", title: "Mock Art 2")]
		mockService.result = .success(artObjects)

		// When
		viewModel.fetchArtObjects()

		// Then
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			XCTAssertEqual(self.viewModel.sectionedArtObjects.count, 1)
			XCTAssertEqual(self.viewModel.sectionedArtObjects[0].sectionTitle, "Page: 1")
			XCTAssertEqual(self.viewModel.sectionedArtObjects[0].sectionArtObjects, artObjects)
			XCTAssertEqual(self.viewModel.numberOfSections, 1)
			XCTAssertEqual(self.viewModel.numberOfItemsInSection(0), 2)
			XCTAssertEqual(self.viewModel.titleForSection(0), "Page: 1")
			expectation.fulfill()
		}

		waitForExpectations(timeout: 5, handler: nil)
	}

	func testFetchArtObjectsFailure() throws {
		// Given
		let expectation = expectation(description: "Art objects fetching failed")
		let error = NSError(domain: "TestError", code: 123, userInfo: nil)
		mockService.result = .failure(error)

		// When
		viewModel.fetchArtObjects()

		// Then
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			XCTAssertEqual(self.viewModel.sectionedArtObjects.count, 0)
			XCTAssertNotNil(self.viewModel.errorMessage)
			XCTAssertTrue(self.viewModel.isLoading == false)
			expectation.fulfill()
		}

		waitForExpectations(timeout: 5, handler: nil)
	}
}

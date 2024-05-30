//
//  ArtObjectDetailViewModelTests.swift
//  Rijks MuseumTests
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import XCTest
@testable import Rijks_Museum

class ArtObjectDetailViewModelTests: XCTestCase {

	func testGetArtObject() throws {
		// Given
		let mockArtObject = ArtObject.mock()
		let viewModel = ArtObjectDetailViewModel(artObject: mockArtObject)

		// When
		let returnedArtObject = viewModel.getArtObject()

		// Then
		XCTAssertEqual(returnedArtObject.id, "1")
		XCTAssertEqual(returnedArtObject.title, "Mock Art")
		XCTAssertEqual(returnedArtObject.principalOrFirstMaker, "Mock Artist")
	}
}

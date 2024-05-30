//
//  ArtObjectDetailViewModel.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

class ArtObjectDetailViewModel {
	private let artObject: ArtObject
	
	init(artObject: ArtObject) {
		self.artObject = artObject
	}
	
	func getArtObject() -> ArtObject {
		return artObject
	}
}

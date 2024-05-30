//
//  ArtObjectsViewModel.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation
import Combine

class ArtObjectsViewModel: ObservableObject {
	@Published var sectionedArtObjects: [(sectionTitle: String, sectionArtObjects: [ArtObject])] = []
	@Published var errorMessage: String?
	@Published var isLoading: Bool = false

	private var currentPage: Int = 1
	private var cancellables = Set<AnyCancellable>()
	private let artObjectsService: ArtObjectsServiceInterface

	init(artObjectsService: ArtObjectsServiceInterface) {
		self.artObjectsService = artObjectsService
	}

	func fetchArtObjects() {
		isLoading = true
		
		artObjectsService.fetchArtObjects(page: currentPage)
			.sink { [weak self] completion in
				guard let self else { return }
				self.isLoading = false
				if case let .failure(error) = completion {
					self.errorMessage = error.localizedDescription
				}
			} receiveValue: { [weak self] artObjects in
				guard let self else { return }
				self.sectionedArtObjects.append(("Page: \(self.currentPage)", artObjects))
				self.currentPage += 1
			}
			.store(in: &cancellables)
	}
	
	// MARK: CollectionView Helpers
	
	func artObject(at indexPath: IndexPath) -> ArtObject? {
		guard indexPath.section < sectionedArtObjects.count else {
			return nil // Section index out of bounds
		}
		
		let section = sectionedArtObjects[indexPath.section]
		
		guard indexPath.row < section.sectionArtObjects.count else {
			return nil // Row index out of bounds
		}
		
		return section.sectionArtObjects[indexPath.row]
	}

	var numberOfSections: Int {
		sectionedArtObjects.count
	}

	func numberOfItemsInSection(_ section: Int) -> Int {
		guard section >= 0, section < sectionedArtObjects.count else {
			return 0
		}
		return sectionedArtObjects[section].sectionArtObjects.count
	}

	func titleForSection(_ section: Int) -> String {
		guard section >= 0, section < sectionedArtObjects.count else {
			return ""
		}
		return sectionedArtObjects[section].sectionTitle
	}
}

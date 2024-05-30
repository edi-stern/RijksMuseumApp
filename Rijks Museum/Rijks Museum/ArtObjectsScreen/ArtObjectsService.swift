//
//  ArtObjectsService.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation
import Combine

protocol ArtObjectsServiceInterface {
	func fetchArtObjects(page: Int) -> AnyPublisher<[ArtObject], Error>
}

class ArtObjectsService: ArtObjectsServiceInterface {
	private let networkService: NetworkServiceInterface

	init(networkService: NetworkServiceInterface) {
		self.networkService = networkService
	}

	func fetchArtObjects(page: Int) -> AnyPublisher<[ArtObject], Error> {
		return Future { [weak self] promise in
			guard let self = self else { return }

			Task {
				do {
					let urlRequest = try ApiRouter.getArtObjects(page: page).asURLRequest()
					let response: MuseumData = try await self.networkService.request(urlRequest)
					promise(.success(response.artObjects.filter({ $0.hasImage })))
				} catch {
					promise(.failure(error))
				}
			}
		}
		.eraseToAnyPublisher()
	}
}

#if DEBUG
class MockArtObjectsService: ArtObjectsServiceInterface {
	var result: Result<[ArtObject], Error>?

	func fetchArtObjects(page: Int) -> AnyPublisher<[ArtObject], Error> {
		if let result = result {
			// Return a publisher that immediately emits the result
			return Result.Publisher(result).eraseToAnyPublisher()
		} else {
			// Return a publisher that immediately fails if result is not set
			let error = NSError(domain: "MockArtObjectsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock result not set"])
			return Fail(error: error).eraseToAnyPublisher()
		}
	}
}

#endif

//
//  NetworkService.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

protocol NetworkServiceInterface {
	func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

class NetworkService: NetworkServiceInterface {
	func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
		let (data, response) = try await URLSession.shared.data(for: urlRequest)

		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
			if let httpResponse = response as? HTTPURLResponse {
				switch httpResponse.statusCode {
				case 403:
					throw ApiError.forbidden
				case 404:
					throw ApiError.notFound
				case 409:
					throw ApiError.conflict
				case 500:
					throw ApiError.internalServerError
				default:
					throw ApiError.unknown
				}
			}
			throw ApiError.unknown
		}

		do {
			let decodedData = try JSONDecoder().decode(T.self, from: data)
			return decodedData
		} catch {
			throw ApiError.decodingError(error)
		}
	}
}

#if DEBUG
class MockNetworkService: NetworkServiceInterface {
	var result: Result<MuseumData, Error>?
	
	func request<T>(_ request: URLRequest) async throws -> T where T : Decodable {
		if let result = result {
			switch result {
			case .success(let data):
				return data as! T
			case .failure(let error):
				throw error
			}
		} else {
			fatalError("MockNetworkService result not set")
		}
	}
}
#endif


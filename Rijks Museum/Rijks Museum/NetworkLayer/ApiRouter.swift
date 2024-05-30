//
//  ApiRouter.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

enum ApiRouter {
	//The endpoint name we'll call later
	case getArtObjects(page: Int)
	
	//MARK: - HttpMethod
	var method: String {
		switch self {
		case .getArtObjects:
			return "GET"
		}
	}
	
	//MARK: - Path
	var path: String {
		switch self {
		case .getArtObjects:
			return "/api/en/collection"
		}
	}
	
	//MARK: - Parameters
	var parameters: [String: String] {
		switch self {
		case let .getArtObjects(page):
			return [
				Constants.Parameters.apiKey: Constants.Values.apiKeyValue,
				Constants.Parameters.page: page.description,
				Constants.Parameters.imgOnly: Constants.Values.trueValue,
				Constants.Parameters.topPieces: Constants.Values.trueValue,
				Constants.Parameters.type: Constants.Values.painting,
				Constants.Parameters.sort: Constants.Values.sort,
			]
		}
	}
}

// MARK: Return URLRequest

extension ApiRouter {
	func asURLRequest() throws -> URLRequest {
		guard var urlComponents = URLComponents(string: Constants.baseUrl) else {
			throw ApiError.notFound
		}
		urlComponents.path = path
		urlComponents.queryItems = parameters.map {
			URLQueryItem(
				name: $0.key,
				value: $0.value
			)
		}

		guard let url = urlComponents.url else {
			throw ApiError.notFound
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method

		return urlRequest
	}
}

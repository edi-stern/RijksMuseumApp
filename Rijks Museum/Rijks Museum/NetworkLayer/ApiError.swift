//
//  ApiError.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

enum ApiError: Error {
	case forbidden              //Status code 403
	case notFound               //Status code 404
	case conflict               //Status code 409
	case internalServerError    //Status code 500
	case decodingError(Error)
	case unknown

	var description: String {
		switch self {
		case .forbidden:
			return "Forbidden error"
		case .notFound:
			return "Not found error"
		case .conflict:
			return "Conflict error"
		case .internalServerError:
			return "Internal server error"
		case .decodingError(let error):
			return "Decoding error: \(error.localizedDescription)"
		case .unknown:
			return "Unknown"
		}
	}
}

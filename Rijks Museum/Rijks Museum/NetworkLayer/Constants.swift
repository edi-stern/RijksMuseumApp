//
//  Constants.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

struct Constants {
	static let baseUrl = "https://www.rijksmuseum.nl"
	
	struct Parameters {
		static let apiKey = "key"
		static let page = "p"
		static let sort = "s"
		static let imgOnly = "imgonly"
		static let topPieces = "toppieces"
		static let type = "type"
	}
	
	struct Values {
		static let apiKeyValue = "0fiuZFh4"
		static let sort = "artist"
		static let trueValue = "true"
		static let painting = "painting"
	}
}

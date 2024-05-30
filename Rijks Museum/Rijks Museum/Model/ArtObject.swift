//
//  ArtObject.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

// MARK: - ArtObject
public struct ArtObject: Decodable {
	public let links: Links
	public let id: String
	public let title: String
	public let hasImage: Bool
	public let principalOrFirstMaker: String
	public let longTitle: String
	public let webImage: Image?
}

// MARK: - Links
public struct Links: Decodable {
	public let selfLink: String
	public let web: String
	
	enum CodingKeys: String, CodingKey {
		case selfLink = "self"
		case web
	}
}

// MARK: - Image
public struct Image: Decodable {
	public let url: String
}

#if DEBUG
public extension ArtObject {
	static func mock(id: String = "1",
					 title: String = "Mock Art",
					 principalOrFirstMaker: String = "Mock Artist",
					 longTitle: String = "Mock Long Title",
					 imageUrl: String = "https://example.com/mock.jpg") -> ArtObject {
		return ArtObject(links: Links(selfLink: "", web: ""),
						 id: id,
						 title: title,
						 hasImage: true,
						 principalOrFirstMaker: principalOrFirstMaker,
						 longTitle: longTitle,
						 webImage: Image(url: imageUrl))
	}
}

extension ArtObject: Equatable {
	public static func == (lhs: ArtObject, rhs: ArtObject) -> Bool {
		lhs.id == rhs.id
	}
}
#endif

//
//  MuseumData.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation

// MARK: - MuseumData
public struct MuseumData: Decodable {
	public let artObjects: [ArtObject]
}


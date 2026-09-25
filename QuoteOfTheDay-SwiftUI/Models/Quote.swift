//
//  QuotesResponse.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import Foundation

struct Quote: Codable {
	let quote: String
	let author: String

	enum CodingKeys: String, CodingKey {
		case quote = "q"
		case author = "a"
	}
}

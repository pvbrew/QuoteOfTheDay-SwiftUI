//
//  FavouriteQuote.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 28/9/26.
//

import Foundation
import SwiftData

@Model
class FavouriteQuote: Identifiable {
	var quote: String
	var author: String
	
	init(quote: String, author: String) {
		self.quote = quote
		self.author = author
	}
}

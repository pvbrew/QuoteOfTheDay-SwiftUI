//
//  FavouriteView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 16/10/26.
//

import SwiftUI

struct FavouriteView: View {
	private let quote: Quote
	
	init(quote: Quote) {
		self.quote = quote
	}
	
    var body: some View {
		VStack(alignment: .leading, spacing: 16.0) {
			Text(quote.quote)
				.font(.title2)
			HStack {
				Spacer()
				Text(quote.author)
					.font(.caption)
					.accessibilityLabel("by \(quote.author)")
			}
		}
		.accessibilityElement(children: .combine)
		.padding()
    }
}

#Preview {
	FavouriteView(quote: Quote(quote: "Quote", author: "Author"))
}

//
//  QuoteView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import SwiftUI
import SwiftData

struct QuoteView: View {
	let quote: Quote
	let onFetchNewQuote: () -> Void
	let onFavouriteToggle: () -> Void
	@Environment(\.modelContext) private var context
	@Query private var favouriteQuotes: [FavouriteQuote]
	
    var body: some View {
		VStack(spacing: 8.0) {
			Spacer()
			HStack(spacing: 24.0) {
				VStack {
					Text(quote.quote)
						.font(.title)
					Text(quote.author)
						.font(.caption)
				}
				Button {
					onFavouriteToggle()
				} label: {
					Image(systemName: isQuoteFavourite() ? "heart.fill" : "heart")	// TODO: Show heart or heart.fill based on favourite status
				}
			}
			Spacer()
			Button("New Quote") {
				onFetchNewQuote()
			}
		}
    }
	
	private func isQuoteFavourite() -> Bool {
		favouriteQuotes.contains { favouriteQuote in
			favouriteQuote.quote == quote.quote && favouriteQuote.author == quote.author
		}
	}
}

#Preview {
	QuoteView(
		quote: Quote(quote: "Quote", author: "Author"),
		onFetchNewQuote: {},
		onFavouriteToggle: {}
	)
}

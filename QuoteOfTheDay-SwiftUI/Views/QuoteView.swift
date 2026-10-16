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
	let quoteAggregateModel: QuoteAggregateModel
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
					let isQuoteFavourite = quoteAggregateModel.findFavouriteQuote(
						quote,
						in: favouriteQuotes
					) != nil
					Image(
						systemName: isQuoteFavourite ? "heart.fill" : "heart"
					)
				}
			}
			Spacer()
			Button("New Quote") {
				onFetchNewQuote()
			}
		}
    }
}

#Preview {
	QuoteView(
		quote: Quote(quote: "Quote", author: "Author"),
		quoteAggregateModel: QuoteAggregateModel(),
		onFetchNewQuote: {},
		onFavouriteToggle: {}
	)
}

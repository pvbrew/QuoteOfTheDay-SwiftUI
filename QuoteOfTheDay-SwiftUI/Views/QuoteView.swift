//
//  QuoteView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import SwiftUI
import SwiftData

struct QuoteView: View {
	private let quote: Quote
	let onFetchNewQuote: () -> Void
	let onFavouriteToggle: () -> Void
	@Query private var matchingFavouriteQuotes: [FavouriteQuote]
	
	init(
		quote: Quote,
		onFetchNewQuote: @escaping () -> Void,
		onFavouriteToggle: @escaping () -> Void
	) {
		self.quote = quote
		self.onFetchNewQuote = onFetchNewQuote
		self.onFavouriteToggle = onFavouriteToggle
		_matchingFavouriteQuotes = Query(
			filter: #Predicate<FavouriteQuote> { favouriteQuote in
				favouriteQuote.quote == quote.quote
				&& favouriteQuote.author == quote.author
			})
	}
	
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
					Image(
						systemName: matchingFavouriteQuotes.isEmpty ? "heart" : "heart.fill"
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

#Preview("Favourite quote") {
	let quote = Quote(quote: "Quote", author: "Author")
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	let context = ModelContext(container)
	context.insert(FavouriteQuote(quote: quote.quote, author: quote.author))
	try! context.save()
	
	return QuoteView(quote: quote, onFetchNewQuote: {
	}, onFavouriteToggle: {
	}).modelContainer(container)
}

#Preview("Non favourite quote") {
	let quote = Quote(quote: "Quote", author: "Author")
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	let context = ModelContext(container)
	context.insert(FavouriteQuote(quote: "Quote1", author: "Author1"))
	
	return QuoteView(quote: quote, onFetchNewQuote: {
	}, onFavouriteToggle: {
	}).modelContainer(container)
}

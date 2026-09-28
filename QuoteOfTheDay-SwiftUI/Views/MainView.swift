//
//  MainView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
	@State private var quoteAggregateModel = QuoteAggregateModel()
	@Environment(\.modelContext) private var context
	
    var body: some View {
		VStack(content: {
			switch quoteAggregateModel.loadState {
			case .loading:
				LoadingView()
			case .loaded(let quote):
				QuoteView(quote: quote) {
					Task {
						await fetchRandomQuote()
					}
				} onFavouriteToggle: {
					saveFavourite(quote: quote)
				}
			case .failed(let error):
				ErrorView(error: error.localizedDescription) {
					Task {
						await fetchRandomQuote()
					}
				}
			}
		})
		.padding()
		.task {
			await fetchRandomQuote()
		}
    }
	
	private func fetchRandomQuote() async {
		await quoteAggregateModel.fetchRandomQuote()
	}
	
	private func saveFavourite(quote: Quote) {
		let favouriteQuote = FavouriteQuote(quote: quote.quote, author: quote.author)
		context.insert(favouriteQuote)
		try? context.save()
	}
}

#Preview {
    MainView()
}

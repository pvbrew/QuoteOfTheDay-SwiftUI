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
				QuoteView(
					quote: quote,
					quoteAggregateModel: quoteAggregateModel) {
						Task {
							await fetchRandomQuote()
						}
					} onFavouriteToggle: {
						quoteAggregateModel.saveFavourite(
							quote: quote,
							context: context
						)
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
}

#Preview {
    MainView()
}

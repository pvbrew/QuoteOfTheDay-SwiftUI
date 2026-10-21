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
	@State private var isShowingFavourites = false
	@Environment(\.modelContext) private var context
	@Query private var favouriteQuotes: [FavouriteQuote]

    var body: some View {
		NavigationStack(root: {
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
							quoteAggregateModel.toggleFavourite(
								quote: quote,
								context: context
							)
						}
				case .failed(let error):
					ErrorView(error: error) {
						Task {
							await fetchRandomQuote()
						}
					}
				}
			})
			.toolbar(content: {
				Button {
					isShowingFavourites = true
				} label: {
					Text("Favourites")
				}
			})
			.navigationDestination(isPresented: $isShowingFavourites) {
				FavouritesView()
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

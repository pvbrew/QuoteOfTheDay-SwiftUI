//
//  MainView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
	@State private var quoteAggregateModel: QuoteAggregateModel
	@State private var isShowingFavourites = false
	@Environment(\.modelContext) private var context
	@State private var errorTogglingFavourite: String?
	
	init(
		quoteAggregateModel: QuoteAggregateModel = QuoteAggregateModel()
	) {
		self.quoteAggregateModel = quoteAggregateModel
	}

    var body: some View {
		NavigationStack(root: {
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
							do {
								try quoteAggregateModel.toggleFavourite(
									quote: quote,
									context: context
								)
							} catch {
								errorTogglingFavourite = error.localizedDescription
							}
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
		.alert(
			"Error",
			isPresented: Binding(
				get: { errorTogglingFavourite != nil },
				set: { isPresented in
					if !isPresented {
						errorTogglingFavourite = nil
					}
				}
			),
			actions: {
				Button("OK", role: .cancel) {}
			},
			message: {
				Text(errorTogglingFavourite ?? "")
			}
		)
		.task {
			await fetchRandomQuote()
		}
    }
	
	private func fetchRandomQuote() async {
		await quoteAggregateModel.fetchRandomQuote()
	}
}

#Preview {
	final class MockAPIClient: APIClientProtocol {
		func getRandomQuote() async throws -> Quote {
			Quote(quote: "Quote", author: "Author")
		}
	}
	return MainView(
		quoteAggregateModel: QuoteAggregateModel(apiClient: MockAPIClient())
	)
}

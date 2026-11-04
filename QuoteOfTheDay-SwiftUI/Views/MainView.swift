//
//  MainView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
	enum FetchingQuoteState {
		case loading
		case finished
	}
	
	@State private var quoteAggregateModel: QuoteAggregateModel
	@State private var isShowingFavourites = false
	@Environment(\.modelContext) private var context
	@State private var errorTogglingFavourite: String?
	private var fetchingQuoteState: FetchingQuoteState {
		switch quoteAggregateModel.loadState {
			case .loading: return .loading
			case .loaded, .failed: return .finished
		}
	}
	
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
								await quoteAggregateModel.fetchRandomQuote()
							}
						} onFavouriteToggle: {
							do {
								try quoteAggregateModel.toggleFavourite(
									quote: quote,
									context: context
								)
								return true
							} catch {
								errorTogglingFavourite = error.localizedDescription
								return false
							}
						}
				case .failed(let error):
					ErrorView(error: error) {
						Task {
							await quoteAggregateModel.fetchRandomQuote()
						}
					}
				}
			})
			.animation(.easeInOut, value: fetchingQuoteState)
			.toolbar(content: {
				Button {
					isShowingFavourites = true
				} label: {
					Text("Favourites")
				}
			})
			.navigationDestination(isPresented: $isShowingFavourites) {
				FavouritesView(quoteAggregateModel: quoteAggregateModel)
			}
		})
		.padding()
		.errorAlert(message: $errorTogglingFavourite)
		.task {
			await quoteAggregateModel.fetchRandomQuote()
		}
    }
}

#Preview {
	final class MockAPIClient: APIClientProtocol {
		func getRandomQuote() async throws -> Quote {
			Quote(quote: "Quote", author: "Author")
		}
	}
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	return MainView(
		quoteAggregateModel: QuoteAggregateModel(apiClient: MockAPIClient())
	)
	.modelContainer(container)
}

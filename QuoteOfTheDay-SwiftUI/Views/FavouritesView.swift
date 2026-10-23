//
//  FavouritesView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 2/10/26.
//

import SwiftUI
import SwiftData

struct FavouritesView: View {
	@Query private var favouriteQuotes: [FavouriteQuote]
	@Environment(\.modelContext) private var context
	private let quoteAggregateModel: QuoteAggregateModel
	@State private var errorDeletingFavourite: String?
	
	init(quoteAggregateModel: QuoteAggregateModel) {
		self.quoteAggregateModel = quoteAggregateModel
	}
	
    var body: some View {
		if !favouriteQuotes.isEmpty {
			List {
				ForEach(favouriteQuotes) { favouriteQuote in
					FavouriteView(
						quote: Quote(
							quote: favouriteQuote.quote,
							author: favouriteQuote.author
						)
					)
					.listRowBackground(Color.clear)
				}
				.onDelete { indexSet in
					indexSet.forEach { index in
						do {
							try quoteAggregateModel.removeFavourite(
								quote: favouriteQuotes[index],
								context: context
							)
						} catch {
							errorDeletingFavourite = error.localizedDescription
						}
					}
				}
			}
			.scrollContentBackground(.hidden)
			.errorAlert(message: $errorDeletingFavourite)
		} else {
			ContentUnavailableView("No favourites", systemImage: "heart.slash")
		}
    }
}

#Preview("With favourites") {
	final class MockAPIClient: APIClientProtocol {
		func getRandomQuote() async throws -> Quote {
			Quote(quote: "Quote", author: "Author")
		}
	}
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	let context = ModelContext(container)
	context.insert(FavouriteQuote(quote: "Quote", author: "Author"))
	context.insert(FavouriteQuote(quote: "Quote", author: "Author"))
	try! context.save()
	return FavouritesView(
		quoteAggregateModel: QuoteAggregateModel(apiClient: MockAPIClient())
	)
	.modelContainer(container)
}

#Preview("No favourites") {
	final class MockAPIClient: APIClientProtocol {
		func getRandomQuote() async throws -> Quote {
			Quote(quote: "Quote", author: "Author")
		}
	}
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	return FavouritesView(
		quoteAggregateModel: QuoteAggregateModel(apiClient: MockAPIClient())
	)
	.modelContainer(container)
}

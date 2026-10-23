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
	@Environment(QuoteAggregateModel.self) private var quoteAggregateModel
	@State private var errorDeletingFavourite: String?
	
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
			.alert(
				"Error",
				isPresented: Binding(
					get: { errorDeletingFavourite != nil },
					set: { isPresented in
						if !isPresented {
							errorDeletingFavourite = nil
						}
					}
				),
				actions: {
					Button("OK", role: .cancel) {}
				},
				message: {
					Text(errorDeletingFavourite ?? "")
				}
			)
		} else {
			ContentUnavailableView("No favourites", systemImage: "heart.slash")
		}
    }
}

#Preview("With favourites") {
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	let context = ModelContext(container)
	context.insert(FavouriteQuote(quote: "Quote", author: "Author"))
	context.insert(FavouriteQuote(quote: "Quote", author: "Author"))
	return FavouritesView()
		.modelContainer(container)
}


#Preview("No favourites") {
	let container = try! ModelContainer(
		for: FavouriteQuote.self,
		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
	)
	return FavouritesView()
		.modelContainer(container)
}

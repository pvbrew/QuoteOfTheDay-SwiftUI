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
	
    var body: some View {
		List {
			ForEach(favouriteQuotes) { favouriteQuote in
				Text(favouriteQuote.quote)
			}
			.onDelete { indexSet in
				indexSet.forEach { index in
					context.delete(favouriteQuotes[index])
				}
			}
		}
		.scrollContentBackground(.hidden)
    }
}

#Preview {
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

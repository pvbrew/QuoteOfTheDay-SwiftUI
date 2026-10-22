//
//  QuoteAggregateModel.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import Foundation
import SwiftData

@Observable
final class QuoteAggregateModel {
	var loadState: LoadState = .loading
	private let apiClient: APIClientProtocol
	
	init(apiClient: APIClientProtocol = APIClient()) {
		self.apiClient = apiClient
	}
	
	func fetchRandomQuote() async {
		loadState = .loading
		do {
			loadState = .loaded(try await apiClient.getRandomQuote())
		} catch {
			loadState = .failed(error.localizedDescription)
		}
	}
	
	func toggleFavourite(quote: Quote, context: ModelContext) throws {
		if let favouriteQuote = try findFavourite(
			quote: quote,
			context: context
		) {
			removeFavourite(quote: favouriteQuote, context: context)
		} else {
			saveFavourite(quote: quote, context: context)
		}
	}
	
	private func saveFavourite(quote: Quote, context: ModelContext) {
		let favouriteQuote = FavouriteQuote(
			quote: quote.quote,
			author: quote.author
		)
		context.insert(favouriteQuote)
		try? context.save()
	}
	
	private func removeFavourite(quote: FavouriteQuote, context: ModelContext) {
		context.delete(quote)
		try? context.save()
	}

	private func findFavourite(
		quote: Quote,
		context: ModelContext
	) throws -> FavouriteQuote? {
		let predicate = #Predicate<FavouriteQuote> { favouriteQuote in
			favouriteQuote.quote == quote.quote
			&& favouriteQuote.author == quote.author
		}
		var descriptor = FetchDescriptor<FavouriteQuote>(predicate: predicate)
		descriptor.fetchLimit = 1
		return try context.fetch(descriptor).first
	}
}

extension QuoteAggregateModel {
	enum LoadState {
		case loading
		case loaded(Quote)
		case failed(String)
	}
}

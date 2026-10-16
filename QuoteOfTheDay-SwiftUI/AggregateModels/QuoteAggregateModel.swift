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
			loadState = .failed(error)
		}
	}
	
	func saveFavourite(quote: Quote, context: ModelContext) {
		let favouriteQuote = FavouriteQuote(
			quote: quote.quote,
			author: quote.author
		)
		context.insert(favouriteQuote)
		try? context.save()
	}
	
	func removeFavourite(quote: FavouriteQuote, context: ModelContext) {
		context.delete(quote)
	}
	
	func findFavouriteQuote(
		_ quote: Quote,
		in favouriteQuotes: [FavouriteQuote]
	) -> FavouriteQuote? {
		favouriteQuotes.first { favouriteQuote in
			favouriteQuote.quote == quote.quote
			&& favouriteQuote.author == quote.author
		}
	}
}

extension QuoteAggregateModel {
	enum LoadState {
		case loading
		case loaded(Quote)
		case failed(Error)
	}
}

//
//  QuoteAggregateModel.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import Foundation

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
}

extension QuoteAggregateModel {
	enum LoadState {
		case loading
		case loaded(Quote)
		case failed(Error)
	}
}

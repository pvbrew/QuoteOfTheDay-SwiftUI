//
//  APIClient.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import Foundation

protocol APIClientProtocol {
	func getRandomQuote() async throws -> Quote
}

struct APIClient: APIClientProtocol {
	private let urlBuilder: URLBuildable
	private let sessionAdapter: SessionAdaptable
	
	init(
		urlBuilder: URLBuildable = URLBuilder(),
		sessionAdapter: SessionAdaptable = SessionAdapter()
	) {
		self.urlBuilder = urlBuilder
		self.sessionAdapter = sessionAdapter
	}
	
	func getRandomQuote() async throws -> Quote {
		let url = urlBuilder.randomQuoteURL
		let (data, response) = try await sessionAdapter.performRequest(
			using: url
		)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.nonHTTPResponse
		}
		
		guard (200..<300).contains(httpResponse.statusCode) else {
			throw NetworkError.unacceptableStatusCode(httpResponse.statusCode)
		}
		let quotesResponse = try JSONDecoder().decode([Quote].self, from: data)
		guard let quote = quotesResponse.first else {
			throw DecodingError.noQuotes
		}
		return quote
	}
}

extension APIClient {
	enum NetworkError: Equatable, Error {
		case nonHTTPResponse
		case unacceptableStatusCode(Int)
	}
	
	enum DecodingError: Error {
		case noQuotes
	}
}

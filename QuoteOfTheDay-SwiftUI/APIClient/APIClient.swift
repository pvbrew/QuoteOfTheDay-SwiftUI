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
		guard let quotesResponse = try? JSONDecoder().decode(
			[Quote].self,
			from: data
		) else {
			throw DecodingError.cannotDecode
		}
		guard let quote = quotesResponse.first else {
			throw DecodingError.noQuotes
		}
		return quote
	}
}

extension APIClient {
	enum NetworkError: Equatable, LocalizedError {
		case nonHTTPResponse
		case unacceptableStatusCode(Int)
		
		var errorDescription: String? {
			switch self {
			case .nonHTTPResponse:
				return "Response is not an HTTP response"
			case .unacceptableStatusCode(let statusCode):
				return "Status code is not acceptable: \(statusCode)"
			}
		}
	}
	
	enum DecodingError: LocalizedError {
		case noQuotes
		case cannotDecode
		
		var errorDescription: String? {
			switch self {
			case .noQuotes:
				return "No quotes found in response"
			case .cannotDecode:
				return "Cannot decode response"
			}
		}
	}
}

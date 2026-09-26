//
//  MockAPIClient.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import Foundation
@testable import QuoteOfTheDay_SwiftUI

final class MockAPIClient: APIClientProtocol {
	private let quote = Quote(quote: "Quote", author: "Author")
	private let error = NSError(domain: "Error", code: 0, userInfo: nil)
	private let shouldThrowError: Bool
	
	init(shouldThrowError: Bool) {
		self.shouldThrowError = shouldThrowError
	}
	
	func getRandomQuote() async throws -> Quote {
		if shouldThrowError {
			throw error
		}
		return quote
	}
}

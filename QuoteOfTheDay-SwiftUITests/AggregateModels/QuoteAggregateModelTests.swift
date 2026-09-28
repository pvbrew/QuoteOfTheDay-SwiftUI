//
//  QuoteAggregateModelTests.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import XCTest
@testable import QuoteOfTheDay_SwiftUI

final class QuoteAggregateModelTests: XCTestCase {
	func testQuoteAggregateModel_whenInitialised_loadStateShouldBeLoading() {
		// When
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)

		// Then
		if case .loading = sut.loadState {
		} else {
			XCTFail()
		}
	}

	func testQuoteAggregateModel_whenFetchRandomQuoteSucceeds_loadStateShouldBeLoaded() async {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)

		// When
		await sut.fetchRandomQuote()

		// Then
		if case .loaded(let quote) = sut.loadState {
			XCTAssertEqual(quote.quote, "Quote")
			XCTAssertEqual(quote.author, "Author")
		} else {
			XCTFail()
		}
	}

	func testQuoteAggregateModel_whenFetchRandomQuoteFails_loadStateShouldBeFailed() async {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: true)
		)

		// When
		await sut.fetchRandomQuote()

		// Then
		if case .failed = sut.loadState {
		} else {
			XCTFail()
		}
	}
}

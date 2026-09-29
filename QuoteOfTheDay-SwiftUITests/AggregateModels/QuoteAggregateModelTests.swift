//
//  QuoteAggregateModelTests.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import XCTest
import SwiftData
@testable import QuoteOfTheDay_SwiftUI

final class QuoteAggregateModelTests: XCTestCase {
	// MARK: - loadState tests
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

	// MARK: - fetchRandomQuote() tests
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
	
	// MARK: - saveFavourite(quote:context) tests
	func testQuoteAggregateModel_whenSaveFavouriteCalled_favouritesShouldContainQuote() throws {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let container = try ModelContainer(
			for: FavouriteQuote.self,
			configurations: ModelConfiguration(isStoredInMemoryOnly: true)
		)
		let context = ModelContext(container)

		// When
		let favouritesBefore = try fetch(fromContext: context)
		XCTAssertTrue(favouritesBefore.isEmpty)
		sut.saveFavourite(quote: quote, context: context)

		// Then
		let favouritesAfter = try fetch(fromContext: context)
		XCTAssertEqual(favouritesAfter.count, 1)
		XCTAssertEqual(favouritesAfter.first?.quote, "Quote")
		XCTAssertEqual(favouritesAfter.first?.author, "Author")
	}
	
	// MARK: - isQuoteFavourite(_:in:) tests
	func testQuoteAggregateModel_whenIsQuoteFavouriteForFavouriteQuote_shouldReturnTrue() {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let favouriteQuotes = [FavouriteQuote(quote: "Quote", author: "Author")]
		
		// When
		let isQuoteFavourite = sut.isQuoteFavourite(quote, in: favouriteQuotes)
		
		// Then
		XCTAssertTrue(isQuoteFavourite)
	}
	
	func testQuoteAggregateModel_whenIsQuoteFavouriteForNonFavouriteQuote_shouldReturnFalse() {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let favouriteQuotes = [
			FavouriteQuote(quote: "Quote1", author: "Author1")
		]
		
		// When
		let isQuoteFavourite = sut.isQuoteFavourite(quote, in: favouriteQuotes)
		
		// Then
		XCTAssertFalse(isQuoteFavourite)
	}
	
	// MARK: - Helper functions
	private func fetch(
		fromContext context: ModelContext
	) throws -> [FavouriteQuote] {
		try context.fetch(FetchDescriptor<FavouriteQuote>())
	}
}

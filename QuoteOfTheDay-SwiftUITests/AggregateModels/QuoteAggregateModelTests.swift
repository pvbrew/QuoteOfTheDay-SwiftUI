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
	
	// MARK: - toggleFavourite(quote:context) tests
	func testQuoteAggregateModel_whenTogglingFavouriteOnFavouriteQuote_thisQuoteShouldNotBeInFavourites() throws {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let favouriteQuote = FavouriteQuote(
			quote: quote.quote,
			author: quote.author
		)
		let container = try ModelContainer(
			for: FavouriteQuote.self,
			configurations: ModelConfiguration(isStoredInMemoryOnly: true)
		)
		let context = ModelContext(container)
		context.insert(favouriteQuote)
		try context.save()
		
		// When
		try sut.toggleFavourite(quote: quote, context: context)
		
		// Then
		XCTAssertTrue(try fetch(fromContext: context).isEmpty)
	}
	
	func testQuoteAggregateModel_whenTogglingFavouriteOnFavouriteQuoteButHasOtherFavouriteQuotes_thisQuoteShouldNotBeInFavourites() throws {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let favouriteQuote = FavouriteQuote(
			quote: quote.quote,
			author: quote.author
		)
		let favouriteQuote2 = FavouriteQuote(quote: "Quote2", author: "Author2")
		let container = try ModelContainer(
			for: FavouriteQuote.self,
			configurations: ModelConfiguration(isStoredInMemoryOnly: true)
		)
		let context = ModelContext(container)
		context.insert(favouriteQuote)
		context.insert(favouriteQuote2)
		try? context.save()
		
		// When
		try sut.toggleFavourite(quote: quote, context: context)
		
		// Then
		let favourites = try fetch(fromContext: context)
		XCTAssertEqual(favourites.count, 1)
		XCTAssertEqual(favourites.first?.quote, "Quote2")
		XCTAssertEqual(favourites.first?.author, "Author2")
	}
	
	func testQuoteAggregateModel_whenTogglingFavouriteOnNonFavouriteQuote_thisQuoteShouldBeInFavourites() throws {
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
		try sut.toggleFavourite(quote: quote, context: context)
		
		// Then
		let favourites = try fetch(fromContext: context)
		XCTAssertEqual(favourites.count, 1)
		XCTAssertEqual(favourites.first?.quote, "Quote")
		XCTAssertEqual(favourites.first?.author, "Author")
	}
	
	// MARK: - Helper functions
	private func fetch(
		fromContext context: ModelContext
	) throws -> [FavouriteQuote] {
		try context.fetch(FetchDescriptor<FavouriteQuote>())
	}
}

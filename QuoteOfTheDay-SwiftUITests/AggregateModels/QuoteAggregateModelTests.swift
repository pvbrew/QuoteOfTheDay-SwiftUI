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
		let favouritesBefore = try fetch(fromContext: context)
		XCTAssertTrue(favouritesBefore.isEmpty)

		// When
		sut.saveFavourite(quote: quote, context: context)

		// Then
		let favouritesAfter = try fetch(fromContext: context)
		XCTAssertEqual(favouritesAfter.count, 1)
		XCTAssertEqual(favouritesAfter.first?.quote, "Quote")
		XCTAssertEqual(favouritesAfter.first?.author, "Author")
	}
	
	// MARK: - removeFavourite(quote:context:) tests
	func testQuoteAggregateModel_whenRemoveFavouriteCalled_favouritesShouldNotContainQuote() throws {
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
		sut.saveFavourite(quote: quote, context: context)
		let favouritesBefore = try fetch(fromContext: context)
		let favouriteQuote = try XCTUnwrap(
			sut.findFavouriteQuote(quote, in: favouritesBefore)
		)
		
		// When
		sut.removeFavourite(quote: favouriteQuote, context: context)
		
		// Then
		let favouritesAfter = try fetch(fromContext: context)
		XCTAssertTrue(favouritesAfter.isEmpty)
	}
	
	// MARK: - findFavouriteQuote(_:in:) tests
	func testQuoteAggregateModel_whenQuoteUnderFindingIsFavourite_shouldReturnTHeFavouriteQuoteObject() {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let favouriteQuotes = [FavouriteQuote(quote: "Quote", author: "Author")]
		
		// When
		let favouriteQuote = sut.findFavouriteQuote(quote, in: favouriteQuotes)
		
		// Then
		XCTAssertEqual(favouriteQuote?.quote, "Quote")
		XCTAssertEqual(favouriteQuote?.author, "Author")
	}
	
	func testQuoteAggregateModel_whenQuoteUnderFindingIsNotFavourite_shouldReturnNil() {
		// Given
		let sut = QuoteAggregateModel(
			apiClient: MockAPIClient(shouldThrowError: false)
		)
		let quote = Quote(quote: "Quote", author: "Author")
		let favouriteQuotes = [
			FavouriteQuote(quote: "Quote1", author: "Author1")
		]
		
		// When
		let favouriteQuote = sut.findFavouriteQuote(quote, in: favouriteQuotes)
		
		// Then
		XCTAssertNil(favouriteQuote)
	}
	
	// MARK: - Helper functions
	private func fetch(
		fromContext context: ModelContext
	) throws -> [FavouriteQuote] {
		try context.fetch(FetchDescriptor<FavouriteQuote>())
	}
}

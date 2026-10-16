//
//  QuoteTests.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import XCTest
@testable import QuoteOfTheDay_SwiftUI

final class QuoteTests: XCTestCase {
	// MARK: - Quote decoding tests
	func testQuote_whenDecodedWithAllTheProperties_sutShouldBeTheExpected() throws{
		// Given
		let fileName = "quote"
		
		// When
		let sut = try makeSut(Quote.self, from: fileName)
		
		// Then
		XCTAssertEqual(sut.quote, "The time is always right to do what is right.")
		XCTAssertEqual(sut.author, "Martin Luther King, Jr.")
	}
	
	func testQuote_whenDecodedFromEmptyJSON_shouldThrow() throws {
		// Given
		let fileName = "empty"

		// When / Then
		XCTAssertThrowsError(try makeSut(Quote.self, from: fileName))
	}

	// MARK: - Helper functions
	private func makeSut<T: Decodable>(
		_ type: T.Type,
		from fileName: String
	) throws -> T {
		let bundle = Bundle(for: Swift.type(of: self))
		let url = try XCTUnwrap(
			bundle.url(forResource: fileName, withExtension: "json")
		)
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode(type, from: data)
	}
}

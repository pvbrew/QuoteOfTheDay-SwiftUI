//
//  URLBuilderTests.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import XCTest
@testable import QuoteOfTheDay_SwiftUI

final class URLBuilderTests: XCTestCase {
	func testURLBuilder_whenRandomQuoteURL_shouldReturnTheExpectedURL() {
		// Given
		let sut = URLBuilder()
		
		// When
		let url = sut.randomQuoteURL
		
		// Then
		XCTAssertEqual(url, URL(string: "https://zenquotes.io/api/random")!)
	}
}

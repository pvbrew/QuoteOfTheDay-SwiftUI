//
//  APIClientTests.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import XCTest
@testable import QuoteOfTheDay_SwiftUI

final class APIClientTests: XCTestCase {
	private var mockQuotes: [Quote] {
		try! decode([Quote].self, from: "quotes")
	}
	private let mockURLBuilder = MockURLBuilder()
	
	// MARK: - getRandomQuote() tests
	func testAPIClient_whenGettingRandomQuote_shouldReturnQuoteObject() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockQuotes),
			urlResponse: makeHTTPURLResponse(),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When
		let quote = try await sut.getRandomQuote()
		
		// Then
		XCTAssertEqual(
			quote.quote,
			"The time is always right to do what is right."
		)
		XCTAssertEqual(quote.author, "Martin Luther King, Jr.")
	}
	
	func testAPIClient_whenStatusCodeIsUnacceptable_shouldThrowUnacceptableStatusCodeError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockQuotes),
			urlResponse: makeHTTPURLResponse(withStatusCode: 300),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When Then
		await assertThrowsAsyncError(
			try await sut.getRandomQuote()
		) { error in
			XCTAssertEqual(
				error as? APIClient.NetworkError,
				.unacceptableStatusCode(300)
			)
		}
	}
	
	func testAPIClient_whenSessionAdapterThrows_shouldPropagateError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockQuotes),
			urlResponse: makeHTTPURLResponse(),
			error: NSError(domain: "domain", code: 1)
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When Then
		await assertThrowsAsyncError(
			try await sut.getRandomQuote()
		) { error in
			XCTAssertEqual((error as NSError).domain, "domain")
		}
	}
	
	func testAPIClient_whenResponseIsNotHTTP_shouldThrowNonHTTPResponseError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(model: mockQuotes),
			urlResponse: URLResponse(
				url: URL(string: "https://www.apple.com")!,
				mimeType: nil,
				expectedContentLength: 0,
				textEncodingName: nil
			),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When Then
		await assertThrowsAsyncError(
			try await sut.getRandomQuote()
		) { error in
			XCTAssertEqual(error as? APIClient.NetworkError, .nonHTTPResponse)
		}
	}
	
	func testAPIClient_whenResponseDataIsNotDecodable_shouldThrowDecodingError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: Data("not valid json".utf8),
			urlResponse: makeHTTPURLResponse(),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When Then
		await assertThrowsAsyncError(
			try await sut.getRandomQuote()
		) { error in
			XCTAssertEqual(
				error as? APIClient.DecodingError,
				.cannotDecode
			)
		}
	}
	
	func testAPIClient_whenNoQuotesReturned_shouldThrowNoQuotesError() async throws {
		// Given
		let sessionAdapter = MockSessionAdapter(
			data: try dataFrom(
				model: try! decode([Quote].self, from: "no_quotes")
			),
			urlResponse: makeHTTPURLResponse(),
			error: nil
		)
		let sut = makeSut(withSessionAdapter: sessionAdapter)
		
		// When Then
		await assertThrowsAsyncError(
			try await sut.getRandomQuote()
		) { error in
			XCTAssertEqual(
				error as? APIClient.DecodingError,
				.noQuotes
			)
		}
	}
	
	// MARK: - Helper functions
	private func makeSut(
		withSessionAdapter sessionAdapter: MockSessionAdapter
	) -> APIClient {
		APIClient(urlBuilder: mockURLBuilder, sessionAdapter: sessionAdapter)
	}
	
	private func makeHTTPURLResponse(
		withStatusCode statusCode: Int = 200
	) -> HTTPURLResponse {
		HTTPURLResponse(
			url: URL(string: "https://www.apple.com")!,
			statusCode: statusCode,
			httpVersion: nil,
			headerFields: nil
		)!
	}
	
	private func dataFrom<T: Encodable>(model: T) throws -> Data {
		try JSONEncoder().encode(model)
	}
}

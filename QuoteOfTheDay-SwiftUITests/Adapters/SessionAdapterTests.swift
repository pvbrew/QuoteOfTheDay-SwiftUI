//
//  SessionAdapterTests.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import XCTest
@testable import QuoteOfTheDay_SwiftUI

final class SessionAdapterTests: XCTestCase {
	let url = URL(string: "https://www.apple.com")!
	
	// MARK: - performRequest(using:) tests
	func testSessionAdapter_whenPerformingRequestDoesNotReturnError_dataAndURLResponseShouldNotBeNil() async throws {
		// Given
		let sut = makeSut(withError: nil)
		
		// When
		let (data, urlResponse) = try await sut.performRequest(using: url)
		
		// Then
		XCTAssertNotNil(data)
		XCTAssertNotNil(urlResponse)
	}
	
	func testSessionAdapter_whenPerformRequestReturnsError_shouldThrowError() async throws {
		// Given
		let sut = makeSut(withError: NSError(domain: "domain", code: 1))
		
		// When Then
		await assertThrowsAsyncError(try await sut.performRequest(using: url))
	}
	
	// MARK: - Helper functions
	private func makeSut(withError error: Error?) -> SessionAdapter {
		let session = MockURLSession(
			data: Data(),
			urlResponse: URLResponse(),
			error: error
		)
		return SessionAdapter(session: session)
	}
}

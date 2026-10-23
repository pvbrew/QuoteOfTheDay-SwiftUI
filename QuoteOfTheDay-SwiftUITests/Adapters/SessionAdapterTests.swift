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
	func testSessionAdapter_whenPerformingRequestSucceeds_shouldReturnSessionDataAndResponse() async throws {
		// Given
		let expectedData = Data("quote".utf8)
		let expectedResponse = HTTPURLResponse(
			url: url,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)!
		let session = MockURLSession(
			data: expectedData,
			urlResponse: expectedResponse,
			error: nil
		)
		let sut = SessionAdapter(session: session)

		// When
		let (data, urlResponse) = try await sut.performRequest(using: url)

		// Then
		XCTAssertEqual(data, expectedData)
		XCTAssertTrue(urlResponse === expectedResponse)
	}

	func testSessionAdapter_whenPerformingRequest_shouldPassRequestWithGivenURLToSession() async throws {
		// Given
		let session = MockURLSession(
			data: Data(),
			urlResponse: URLResponse(),
			error: nil
		)
		let sut = SessionAdapter(session: session)

		// When
		_ = try await sut.performRequest(using: url)

		// Then
		XCTAssertEqual(session.receivedRequest?.url, url)
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

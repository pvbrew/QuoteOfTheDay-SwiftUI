//
//  XCTestCase+Async.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import XCTest

extension XCTestCase {
	func assertThrowsAsyncError<T>(
		_ expression: @autoclosure () async throws -> T,
		_ errorHandler: (_ error: Error) -> Void = { _ in }
	) async {
		do {
			_ = try await expression()
			XCTFail("Asynchronous call did not throw an error.")
		} catch {
			errorHandler(error)
		}
	}
}

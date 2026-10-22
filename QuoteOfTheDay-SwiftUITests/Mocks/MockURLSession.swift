//
//  MockURLSession.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import Foundation
@testable import QuoteOfTheDay_SwiftUI

final class MockURLSession: URLSessionProtocol {
	private let data: Data
	private let urlResponse: URLResponse
	private let error: Error?
	private(set) var receivedRequest: URLRequest?

	init(data: Data, urlResponse: URLResponse, error: Error?) {
		self.data = data
		self.urlResponse = urlResponse
		self.error = error
	}
	
	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		receivedRequest = request
		if let error {
			throw error
		}
		return (data, urlResponse)
	}
}

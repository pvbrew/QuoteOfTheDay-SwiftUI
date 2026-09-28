//
//  MockSessionAdapter.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import Foundation
@testable import QuoteOfTheDay_SwiftUI

final class MockSessionAdapter: SessionAdaptable {
	private let data: Data
	private let urlResponse: URLResponse
	private let error: Error?
	
	init(data: Data, urlResponse: URLResponse, error: Error?) {
		self.data = data
		self.urlResponse = urlResponse
		self.error = error
	}
	
	func performRequest(using url: URL) async throws -> (Data, URLResponse) {
		if let error {
			throw error
		}
		return (data, urlResponse)
	}
}

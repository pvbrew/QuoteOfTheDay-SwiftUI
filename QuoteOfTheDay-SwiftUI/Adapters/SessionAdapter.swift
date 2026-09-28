//
//  SessionAdapter.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import Foundation

protocol SessionAdaptable {
	func performRequest(using url: URL) async throws -> (Data, URLResponse)
}

struct SessionAdapter: SessionAdaptable {
	private let session: URLSessionProtocol
	
	init(session: URLSessionProtocol = URLSession.shared) {
		self.session = session
	}
	
	func performRequest(using url: URL) async throws -> (Data, URLResponse) {
		try await session.data(for: URLRequest(url: url))
	}
}

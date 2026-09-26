//
//  XCTestCase+Decoding.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import XCTest

extension XCTestCase {
	func decode<T: Decodable>(
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

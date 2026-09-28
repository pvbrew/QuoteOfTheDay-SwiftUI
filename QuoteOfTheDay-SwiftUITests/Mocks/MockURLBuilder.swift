//
//  MockURLBuilder.swift
//  QuoteOfTheDay-SwiftUITests
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import Foundation
@testable import QuoteOfTheDay_SwiftUI

final class MockURLBuilder: URLBuildable {
	var randomQuoteURL: URL { URL(string: "https://mock.url")! }
}

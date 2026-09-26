//
//  URLBuilder.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import Foundation

protocol URLBuildable {
	var randomQuoteURL: URL { get }
}

struct URLBuilder: URLBuildable {
	var randomQuoteURL: URL { URL(string: "https://zenquotes.io/api/random")! }
}

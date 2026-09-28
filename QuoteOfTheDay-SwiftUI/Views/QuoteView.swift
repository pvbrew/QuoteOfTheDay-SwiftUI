//
//  QuoteView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import SwiftUI

struct QuoteView: View {
	let quote: Quote
	let onFetchNewQuote: () -> Void
	
    var body: some View {
		VStack(spacing: 8.0) {
			Spacer()
			Text(quote.quote)
				.font(.title)
			Text(quote.author)
				.font(.caption)
			Spacer()
			Button("New Quote") {
				onFetchNewQuote()
			}
		}
    }
}

#Preview {
	QuoteView(
		quote: Quote(quote: "Quote", author: "Author"),
		onFetchNewQuote: {}
	)
}

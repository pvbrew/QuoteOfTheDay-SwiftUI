//
//  MainView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import SwiftUI

struct MainView: View {
	@State private var quoteAggregateModel = QuoteAggregateModel()
	
    var body: some View {
		VStack(content: {
			switch quoteAggregateModel.loadState {
			case .loading:
				LoadingView()
			case .loaded(let quote):
				QuoteView(quote: quote) {
					Task {
						await fetchRandomQuote()
					}
				}
			case .failed(let error):
				ErrorView(error: error.localizedDescription) {
					Task {
						await fetchRandomQuote()
					}
				}
			}
		})
		.padding()
		.task {
			await fetchRandomQuote()
		}
    }
	
	private func fetchRandomQuote() async {
		await quoteAggregateModel.fetchRandomQuote()
	}
}

#Preview {
    MainView()
}

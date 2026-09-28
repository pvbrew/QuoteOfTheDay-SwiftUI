//
//  ErrorView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import SwiftUI

struct ErrorView: View {
	let error: String
	let onRetry: () -> Void
	
    var body: some View {
		VStack(spacing: 24.0) {
			Text(error)
				.foregroundStyle(Color.red)
			Button {
				onRetry()
			} label: {
				Text("Retry")
			}
		}
    }
}

#Preview {
	ErrorView(error: "Error", onRetry: {})
}

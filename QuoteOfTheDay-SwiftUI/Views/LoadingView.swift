//
//  LoadingView.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 26/9/26.
//

import SwiftUI

struct LoadingView: View {
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16.0)
				.frame(width: 128.0, height: 128.0)
				.foregroundStyle(Color(.systemGray5))
			ProgressView()
		}
	}
}

#Preview {
    LoadingView()
}

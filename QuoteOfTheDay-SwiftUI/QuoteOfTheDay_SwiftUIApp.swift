//
//  QuoteOfTheDay_SwiftUIApp.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 25/9/26.
//

import SwiftUI
import SwiftData

@main
struct QuoteOfTheDay_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
				.modelContainer(for: FavouriteQuote.self)
        }
    }
}

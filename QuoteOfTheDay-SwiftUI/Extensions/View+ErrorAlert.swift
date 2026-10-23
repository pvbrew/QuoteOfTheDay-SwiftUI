//
//  View+ErrorAlert.swift
//  QuoteOfTheDay-SwiftUI
//
//  Created by Panagiotis Vakalis on 23/10/26.
//

import SwiftUI

extension View {
	func errorAlert(message: Binding<String?>) -> some View {
		alert(
			"Error",
			isPresented: Binding(
				get: { message.wrappedValue != nil },
				set: { isPresented in
					if !isPresented {
						message.wrappedValue = nil
					}
				}
			),
			actions: {
				Button("OK", role: .cancel) {}
			},
			message: {
				Text(message.wrappedValue ?? "")
			}
		)
	}
}

//
//  FrogChatApp.swift
//  FrogChat
//
//  A whimsical swamp-themed skin for BitChat
//  Compatible with the BitChat network
//

import SwiftUI

@main
struct FrogChatApp: App {
    @StateObject private var viewModel = FrogChatViewModel()

    var body: some Scene {
        WindowGroup {
            SwampContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark) // Swamp theme works best in dark mode
        }
    }
}

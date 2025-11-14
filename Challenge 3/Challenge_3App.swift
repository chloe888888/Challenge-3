//
//  Challenge_3App.swift
//  Challenge 3
//
//  Created by Chloe Lin on 7/11/25.
//

import SwiftUI
import SwiftData

@main
struct Challenge_3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // 👇 this turns SwiftData on for MoodEntry
        .modelContainer(for: MoodEntry.self)
    }
}

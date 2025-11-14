//
//  Challenge_3App.swift
//  Challenge 3
//
//  Created by Chloe Lin on 7/11/25.
//

import SwiftUI

@main
struct Challenge_3App: App {
    @StateObject private var moodData = MoodData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(moodData)   
        }
    }
}

//
//  ContentView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 7/11/25.
//


import SwiftUI

struct ContentView: View {

    // 🔹 Share the same stored date as the rest of the app
    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970

    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            Decor()
                .tabItem {
                    Image(systemName: "app.gift.fill")
                    Text("Decorations")
                }

            GalleryView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle.angled.fill")
                    Text("Gallery")
                }

            // ✅ Use the stored demoCurrentDate instead of plain Date()
            StatisticsView(month: Date(timeIntervalSince1970: demoCurrentDate))
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Statistics")
                }
        }
    }
}

#Preview {
    ContentView()
}


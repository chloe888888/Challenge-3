//
//  ContentView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 7/11/25.
//
import SwiftUI
struct ContentView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    ZStack{
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
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
            StatisticsView(month: Date())
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




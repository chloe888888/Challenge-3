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
                        Image("house.fill")
                        Text("Home")
                    }
                }
            CalendarView()
                .tabItem {
                    Image("calendar")
                    Text("Calendar")
                }
            Decor()
                .tabItem {
                    Image("app.gift.fill")
                    Text("Decorations")
                }
            GalleryView()
                    .tabItem {
                    Image("photo.on.rectangle.angled.fill")
                    Text("Gallery")
                }
            StatisticsView(month: Date())
                .tabItem {
                    Image("chart.bar.xaxis")
                    Text("Statistics")
                }
        }
    }
}
#Preview {
    ContentView()
}




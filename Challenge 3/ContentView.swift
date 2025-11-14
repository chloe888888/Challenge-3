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
                    Image(systemName: "1.circle.fill")
                    Text("Tab 1")
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "2.circle.fill")
                    Text("Tab 2")
                }

            Text("Tab 3")
                .tabItem {
                    Image(systemName: "3.circle.fill")
                    Text("Tab 3")
                }

            Text("Tab 4")
                .tabItem {
                    Image(systemName: "4.circle.fill")
                    Text("Tab 4")
                }

            Text("Tab 5")
                .tabItem {
                    Image(systemName: "5.circle.fill")
                    Text("Tab 5")
                }
        }
    }
}

#Preview {
    ContentView()
}

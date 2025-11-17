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
                        Image("tab1")
                        Text("Home")
                    }
                }

            CalendarView()
                .tabItem {
                    Image("tab2")
                    Text("Calendar")
                }

            Decor()
                .tabItem {
                    Image("tab3")
                    Text("Decorations")
                }

            Text("Tab 4")
                .tabItem {
                    Image("tab4")
                    Text("Gallery")
                }

            StatisticsView()
                .tabItem {
                    Image("tab5")
                    Text("Statistics")
                }
        }
    }
}

#Preview {
    ContentView()
}

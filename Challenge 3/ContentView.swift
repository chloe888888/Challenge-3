import SwiftUI

struct ContentView: View {
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
            
            GalleryView(month: Date(), followDemoDate: true)
                .tabItem {
                    Image(systemName: "photo.on.rectangle.angled.fill")
                    Text("Gallery")
                }
            
          //  StatisticsView(month: Date(), followDemoDate: true)
            //    .tabItem {
              //      Image(systemName: "chart.bar.xaxis")
                //    Text("Statistics")
               // }
            

        }
    }
}

#Preview {
    ContentView()
}

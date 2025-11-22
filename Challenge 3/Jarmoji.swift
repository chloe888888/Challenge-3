

import SwiftUI
import SwiftData
@main
struct Jarmoji: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [MoodEntry.self, MonthlyJar.self])
    }
}



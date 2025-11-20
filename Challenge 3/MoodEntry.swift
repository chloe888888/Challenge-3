

import Foundation
import SwiftData
@Model
class MoodEntry {
    var date: Date
    var emoji: String
    
    init(date: Date, emoji: String) {
        self.date = date
        self.emoji = emoji
    }
}



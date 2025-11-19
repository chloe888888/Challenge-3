//
//  MoodEntry.swift
//  Challenge 3
//
//  Created by Shivani on 14/11/25.
//

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



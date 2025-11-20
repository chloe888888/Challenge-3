//
//  MonthlyJarHelpers.swift
//

import SwiftUI
import SwiftData
import Foundation

@Model
final class MonthlyJar {
    var month: Date
    var label: String
    var dominantCategory: String
    
    init(month: Date, label: String, dominantCategory: String) {
        self.month = month
        self.label = label
        self.dominantCategory = dominantCategory
    }
}

extension ModelContext {
    func monthlyJar(for month: Date) -> MonthlyJar? {
        (try? fetch(FetchDescriptor<MonthlyJar>(
            predicate: #Predicate { $0.month == month }
        )))?.first
    }

  
    func saveMonthlyJar(for month: Date,
                        entries: [MoodEntry],
                        calendar: Calendar = .current) {

        guard !entries.isEmpty else { return }

        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        let label = f.string(from: month).uppercased()

      
        let groups: [String: Set<String>] = [
            "happy": ["😀","😃","😄","😁","😆","😅","😂","🤣","🙂","🙃","😉","😊","😇","😏","🤠","😎","🤡"],
            "sad": ["😞","😔","😟","🙁","☹️","😣","😖","😫","😩","🥺","🥹","😢","😭","😥","😓","😕","😶‍🌫️"],
            "angry": ["😤","😠","😡","🤬","😒","🙄","🤨","😑","😐","🫤","😬","🫨"],
            "love": ["🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋","😛","😝","😜","🤪","🥸","🤓","🧐"],
            "calm": ["😶","😴","😪","😮‍💨","😌","🫥","😑","😐","🫤"],
            "fear": ["😱","😨","😰","😳","😵","😵‍💫","🫢","🫣","🤐","🤫"],
            "disgusted": ["🤢","🤮","🤧","🤥"]
        ]

        var counts = ["happy":0,"sad":0,"angry":0,"love":0,"calm":0,"fear":0,"disgusted":0]
        for e in entries {
            for (cat, set) in groups {
                if set.contains(e.emoji) { counts[cat]! += 1 }
            }
        }

        let dominant = counts.max { $0.value < $1.value }?.key ?? "happy"

     
        if let jar = monthlyJar(for: month) {
            jar.label = label
            jar.dominantCategory = dominant
            try? save()
        } else {
            let jar = MonthlyJar(month: month,
                                 label: label,
                                 dominantCategory: dominant)
            insert(jar)
            try? save()
        }
    }
}

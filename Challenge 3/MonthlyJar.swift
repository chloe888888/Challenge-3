//
//  MonthlyJar.swift
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

    func createOrUpdateMonthlyJar(for monthStart: Date, entries: [MoodEntry]) {
        let cal = Calendar.current

        let existingJar = try? fetch(FetchDescriptor<MonthlyJar>())
            .first(where: { cal.isDate($0.month, equalTo: monthStart, toGranularity: .month) })

        // Categorize
        let category: [String: String] = [
            "😀":"happy","😃":"happy","😄":"happy","😁":"happy","😆":"happy","😅":"happy","😂":"happy","🤣":"happy",
            "🙂":"happy","🙃":"happy","😉":"happy","😊":"happy","😇":"happy","🤠":"happy","😎":"happy","🤡":"happy",

            "😞":"sad","😔":"sad","😟":"sad","🙁":"sad","☹️":"sad","😣":"sad","😖":"sad","😫":"sad","😩":"sad",
            "🥺":"sad","🥹":"sad","😢":"sad","😭":"sad","😥":"sad","😓":"sad","😕":"sad","😶‍🌫️":"sad",

            "😤":"angry","😠":"angry","😡":"angry","🤬":"angry","😒":"angry","🙄":"angry","🤨":"angry","😬":"angry",

            "🥰":"love","😍":"love","🤩":"love","😘":"love","☺️":"love","🤗":"love","😙":"love","😚":"love",

            "😶":"calm","😴":"calm","😪":"calm","😌":"calm","🫥":"calm","😑":"calm","😐":"calm","🫤":"calm",

            "😱":"fear","😨":"fear","😰":"fear","😳":"fear","😵":"fear","😵‍💫":"fear","🫢":"fear","🫣":"fear",

            "🤢":"disgusted","🤮":"disgusted","🤧":"disgusted","🤥":"disgusted"
        ]

        let categoryCount = Dictionary(grouping: entries.map { category[$0.emoji] ?? "happy" }) { $0 }
            .mapValues { $0.count }

        let dominant = categoryCount.max(by: { $0.value < $1.value })?.key ?? "happy"

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let newLabel = formatter.string(from: monthStart).uppercased()

        if let jar = existingJar {
            jar.label = newLabel
            jar.dominantCategory = dominant
        } else {
            let jar = MonthlyJar(
                month: monthStart,
                label: newLabel,
                dominantCategory: dominant
            )
            insert(jar)
        }

        try? save()
    }
}

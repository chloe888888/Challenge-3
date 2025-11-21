//
//  StatisticsView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 18/11/25.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {

    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]
    @Environment(\.modelContext) private var modelContext


    @State var month: Date
    let followDemoDate: Bool

    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970

    private var calendar: Calendar { Calendar.current }


    private var demoMonthStart: Date {
        let d = Date(timeIntervalSince1970: demoCurrentDate)
        return calendar.date(from: calendar.dateComponents([.year, .month], from: d)) ?? d
    }

    private var previousDemoMonthStart: Date {
        calendar.date(byAdding: .month, value: -1, to: demoMonthStart)!
    }

    private var currentMonthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: month)) ?? month
    }

    private var monthTitle: String {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        return f.string(from: currentMonthStart).uppercased()
    }


    private var canGoLeft: Bool {
        currentMonthStart > previousDemoMonthStart
    }

    private var canGoRight: Bool {
        currentMonthStart < demoMonthStart
    }

    private func goLeft() {
        guard canGoLeft else { return }
        if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonthStart) {
            month = newMonth
        }
    }

    private func goRight() {
        guard canGoRight else { return }
        if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonthStart) {
            month = newMonth
        }
    }

    private func syncIfNeeded() {
        guard followDemoDate else { return }
        let demo = demoMonthStart
        if !calendar.isDate(demo, equalTo: month, toGranularity: .month) {
            month = demo
        }
    }


    private var monthEntries: [MoodEntry] {
        entries.filter {
            calendar.isDate($0.date, equalTo: currentMonthStart, toGranularity: .month)
        }
    }

    private let groups: [String: Set<String>] = [
        "happy": ["😀","😃","😄","😁","😆","😅","😂","🤣","🙂","🙃","😉","😊","😇","😏","🤠","😎","🤡"],
        "sad": ["😞","😔","😟","🙁","☹️","😣","😖","😫","😩","🥺","🥹","😢","😭","😥","😓","😕","😶‍🌫️"],
        "angry": ["😤","😠","😡","🤬","😒","🙄","🤨","😑","😐","🫤","😬","🫨"],
        "love": ["🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋","😛","😝","😜","🤪","🥸","🤓","🧐"],
        "calm": ["😶","😴","😪","😮‍💨","😌","🫥","😑","😐","🫤"],
        "fear": ["😱","😨","😰","😳","😵","😵‍💫","🫢","🫣","🤐","🤫"],
        "disgusted": ["🤢","🤮","🤧","🤥"]
    ]

    private var counts: [String: Int] {
        var c = ["happy":0,"sad":0,"angry":0,"love":0,"calm":0,"fear":0,"disgusted":0]

        for entry in monthEntries {
            for (cat, set) in groups {
                if set.contains(entry.emoji) { c[cat]! += 1 }
            }
        }
        return c
    }

    private var dominant: (String, Int, String)? {
        let icons: [String: String] = [
            "happy":"😊","sad":"😢","angry":"😠","love":"🥰",
            "calm":"😌","fear":"😨","disgusted":"🤢"
        ]

        let best = counts.max(by: {$0.value < $1.value})
        if let (category, count) = best, count > 0 {
            return (category, count, icons[category]!)
        }
        return nil
    }


    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                HStack {
                    Button(action: goLeft) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .disabled(!canGoLeft)
                    .opacity(canGoLeft ? 1 : 0.2)

                    Spacer()

                    Text(monthTitle)
                        .font(.system(size: 26, weight: .semibold))

                    Spacer()

                    Button(action: goRight) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .disabled(!canGoRight)
                    .opacity(canGoRight ? 1 : 0.2)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color(red: 0.7, green: 0.95, blue: 0.8))

                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text("STATS")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.bottom, 4)

                    StatRow(label: "happy", emoji: "😊", count: counts["happy"]!)
                    StatRow(label: "sad", emoji: "😢", count: counts["sad"]!)
                    StatRow(label: "angry", emoji: "😠", count: counts["angry"]!)
                    StatRow(label: "love", emoji: "🥰", count: counts["love"]!)
                    StatRow(label: "calm", emoji: "😌", count: counts["calm"]!)
                    StatRow(label: "fear", emoji: "😨", count: counts["fear"]!)
                    StatRow(label: "disgusted", emoji: "🤢", count: counts["disgusted"]!)

                    if let best = dominant {
                        StatRow(label: "Most: \(best.0)", emoji: best.2, count: best.1)
                            .padding(.top, 6)
                    }
                }
                .padding(20)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(red: 0.5, green: 0.85, blue: 0.7), lineWidth: 3)
                )
                .padding(.horizontal, 32)

                Spacer()
            }
            .background(Color(red: 0.95, green: 0.99, blue: 0.97))
            .navigationTitle("Statistics")
        }
        .onAppear { syncIfNeeded() }
        .onChange(of: demoCurrentDate) { _ in syncIfNeeded() }
    }
}

struct StatRow: View {
    let label: String
    let emoji: String
    let count: Int

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 22))
                .frame(width: 150, alignment: .leading)

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 2)

            Text("\(count)")
                .font(.system(size: 24, weight: .bold))
                .frame(width: 40)
        }
    }
}

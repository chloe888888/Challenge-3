//
//  StatisticsView.swift
//  Challenge 3
//
//  Created by Shivanishri on 14/11/25.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    let month: Date

    // happy
    private let happyEmojis: Set<String> = [
        "😀","😃","😄","😁","😆","😅","😂","🤣","🙂","🙃","😉","😊","😇"
    ]

    // sad
    private let sadEmojis: Set<String> = [
        "😞","😔","😟","🙁","☹️","😣","😖","😫","😩","🥺","🥹","😢","😭","😥","😓","😕"
    ]

    // angry
    private let angryEmojis: Set<String> = [
        "😤","😠","😡","🤬","😒","🙄","😏","🤨","😑","😐","🫤","😬","🫨"
    ]

    // love
    private let loveEmojis: Set<String> = [
        "🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋",
        "😛","😝","😜","🤪","🤠","😎","🥸","🤓","🧐"
    ]

    // calm
    private let calmEmojis: Set<String> = [
        "😶","😴","😪","😮‍💨","😌","🫥"
    ]

    // fear
    private let fearEmojis: Set<String> = [
        "😱","😨","😰","😳","😵","😵‍💫","😶‍🌫️","🫢","🫣","🤐","🤫"
    ]

    // disgusted
    private let disgustedEmojis: Set<String> = [
        "🤢","🤮","🤧","💩","🤥","🤡"
    ]

    private var monthlyCounts: [(category: String, count: Int, emoji: String)] {
        let calendar = Calendar.current

        let monthEntries = entries.filter {
            calendar.isDate($0.date, equalTo: month, toGranularity: .month) &&
            calendar.isDate($0.date, equalTo: month, toGranularity: .year)
        }

        var counts: [String: Int] = [
            "happy": 0,
            "sad": 0,
            "angry": 0,
            "love": 0,
            "calm": 0,
            "fear": 0,
            "disgusted": 0
        ]

        for entry in monthEntries {
            let emoji = entry.emoji

            if happyEmojis.contains(emoji) {
                counts["happy", default: 0] += 1
            } else if sadEmojis.contains(emoji) {
                counts["sad", default: 0] += 1
            } else if angryEmojis.contains(emoji) {
                counts["angry", default: 0] += 1
            } else if loveEmojis.contains(emoji) {
                counts["love", default: 0] += 1
            } else if calmEmojis.contains(emoji) {
                counts["calm", default: 0] += 1
            } else if fearEmojis.contains(emoji) {
                counts["fear", default: 0] += 1
            } else if disgustedEmojis.contains(emoji) {
                counts["disgusted", default: 0] += 1
            }
        }

        return [
            ("happy",     counts["happy"]!,     "😊"),
            ("sad",       counts["sad"]!,       "😢"),
            ("angry",     counts["angry"]!,     "😠"),
            ("love",      counts["love"]!,      "🥰"),
            ("calm",      counts["calm"]!,      "😌"),
            ("fear",      counts["fear"]!,      "😨"),
            ("disgusted", counts["disgusted"]!, "🤢")
        ]
    }

    private var dominantEmotion: (category: String, count: Int, emoji: String)? {
        guard let best = monthlyCounts.max(by: { $0.count < $1.count }),
              best.count > 0 else {
            return nil
        }
        return best
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: month).uppercased()
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Text("STATISTICS:")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)

                Text(monthYearString)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.vertical, 25)
            .background(Color(red: 0.7, green: 0.95, blue: 0.8))
            .padding(.bottom, 10)

            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("STATS")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 15)

                    ForEach(monthlyCounts, id: \.category) { item in
                        StatRow(label: item.category,
                                emoji: item.emoji,
                                count: item.count)
                    }
                    .padding(.horizontal, 20)

                    if let best = dominantEmotion {
                        StatRow(label: "appears most",
                                emoji: best.emoji,
                                count: best.count)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 20)
                    } else {
                        HStack {
                            Text("appears most")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)

                            Spacer()

                            Text("—")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                    }
                }
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.5, green: 0.85, blue: 0.7), lineWidth: 3)
                )
                .padding(.horizontal, 30)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.95, green: 0.99, blue: 0.97))
    }
}

struct StatRow: View {
    let label: String
    let emoji: String
    let count: Int

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(size: 22, weight: .regular))
                .frame(width: 150, alignment: .leading)

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 2)
                .frame(maxWidth: .infinity)

            Text("\(count)")
                .font(.system(size: 26, weight: .bold))
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView(month: Date())
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

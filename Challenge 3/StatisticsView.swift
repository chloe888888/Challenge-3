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
    
    private let happyEmojis: Set<String> = [
        "😀","😃","😄","😁","😆","😅","😂","🤣","🙂","🙃","😉","😊","😇"
    ]
    private let sadEmojis: Set<String> = [
        "😞","😔","😟","🙁","☹️","😣","😖","😫","😩","🥺","🥹","😢","😭","😥","😓","😕"
    ]
    private let angryEmojis: Set<String> = [
        "😤","😠","😡","🤬","😒","🙄","😏","🤨","😑","😐","🫤","😬","🫨"
    ]
    private let afraidEmojis: Set<String> = [
        "😱","😨","😰","😳","😵","😵‍💫","😶‍🌫️","🫢","🫣","🤐","🤫"
    ]
    private let disgustedEmojis: Set<String> = [
        "🤢","🤮","🤧","💩","🤥","🤡"
    ]
    private let surprisedEmojis: Set<String> = [
        "😯","😲","🤯","😮"
    ]
    private let excitedEmojis: Set<String> = [
        "🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋","😛","😝","😜","🤪","🤠","😎","🥸","🤓","🧐"
    ]
    private let neutralEmojis: Set<String> = [
        "😶","😴","😪","😮‍💨","😌","🫥"
    ]
    private let tiredEmojis: Set<String> = [
        "🥱","🤒","🤕","🥵","🥶"
    ]
    
    private var monthlyCounts: [(category: String, count: Int, emoji: String)] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let monthEntries = entries.filter {
            calendar.isDate($0.date, equalTo: currentDate, toGranularity: .month) &&
            calendar.isDate($0.date, equalTo: currentDate, toGranularity: .year)
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
            if happyEmojis.contains(entry.emoji) {
                counts["happy", default: 0] += 1
            } else if sadEmojis.contains(entry.emoji) {
                counts["sad", default: 0] += 1
            } else if angryEmojis.contains(entry.emoji) {
                counts["angry", default: 0] += 1
            } else if excitedEmojis.contains(entry.emoji) {
                counts["love", default: 0] += 1
            } else if neutralEmojis.contains(entry.emoji) {
                counts["calm", default: 0] += 1
            } else if afraidEmojis.contains(entry.emoji) {
                counts["fear", default: 0] += 1
            } else if disgustedEmojis.contains(entry.emoji) {
                counts["disgusted", default: 0] += 1
            }
        }
        
        return [
            ("happy", counts["happy"]!, "😊"),
            ("sad", counts["sad"]!, "😢"),
            ("angry", counts["angry"]!, "😠"),
            ("love", counts["love"]!, "🥰"),
            ("calm", counts["calm"]!, "😌"),
            ("fear", counts["fear"]!, "😨"),
            ("disgusted", counts["disgusted"]!, "🤢")
        ]
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: Date()).uppercased()
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
            
            VStack(spacing: 30) {
                Image(systemName: "triangle")
                    .font(.system(size: 80))
                    .foregroundColor(.black.opacity(0.1))
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("STATS")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 15)
                    
                    ForEach(monthlyCounts, id: \.category) { item in
                        StatRow(
                            label: item.category,
                            emoji: item.emoji,
                            count: item.count
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
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
                .frame(width: 110, alignment: .leading)
            
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
    StatisticsView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

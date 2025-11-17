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
    
    // MARK: - Emoji groups that match the VISIBLE categories
    
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
    
    // love  (previously called “excited”)
    private let loveEmojis: Set<String> = [
        "🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋",
        "😛","😝","😜","🤪","🤠","😎","🥸","🤓","🧐"
    ]
    
    // calm  (previously “neutral”)
    private let calmEmojis: Set<String> = [
        "😶","😴","😪","😮‍💨","😌","🫥"
    ]
    
    // fear  (previously “afraid”)
    private let fearEmojis: Set<String> = [
        "😱","😨","😰","😳","😵","😵‍💫","😶‍🌫️","🫢","🫣","🤐","🤫"
    ]
    
    // disgusted
    private let disgustedEmojis: Set<String> = [
        "🤢","🤮","🤧","💩","🤥","🤡"
    ]
    
    // MARK: - Counting for current month
    
    private var monthlyCounts: [(category: String, count: Int, emoji: String)] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // only entries from THIS month + year
        let monthEntries = entries.filter {
            calendar.isDate($0.date, equalTo: currentDate, toGranularity: .month) &&
            calendar.isDate($0.date, equalTo: currentDate, toGranularity: .year)
        }
        
        // keys match exactly what you display in the UI
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
        
        // Order of rows in the card
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
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: Date()).uppercased()
    }
    
    // MARK: - UI
    
    var body: some View {
        ZStack {
            // background fills behind notch + tab bar
            Color(red: 0.95, green: 0.99, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ===== HEADER =====
                ZStack(alignment: .bottomLeading) {
                    Color(red: 0.7, green: 0.95, blue: 0.8)
                        .ignoresSafeArea(edges: .top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("STATISTICS:")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(monthYearString)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
                .frame(height: 160)
                
                // ===== CONTENT =====
                VStack(spacing: 30) {
                    Image(systemName: "triangle")
                        .font(.system(size: 80))
                        .foregroundColor(.black.opacity(0.1))
                        .padding(.top, 30)
                    
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
                        .padding(.bottom, 5)
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.5, green: 0.85, blue: 0.7), lineWidth: 3)
                    )
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 32)   // space above the tab bar
                
                Spacer()
            }
        }
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

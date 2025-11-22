//
//  GalleryView.swift
//

//
//  StatisticsView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 18/11/25.
//

//
//  GalleryView.swift
//

//
//  StatisticsView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 18/11/25.
//

//
//  GalleryView.swift
//

//
//  StatisticsView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 18/11/25.
//

//
//  GalleryView.swift
//

//
//  StatisticsView.swift
//  Challenge 3
//
//  Created by La Wun Eain on 18/11/25.
//

import SwiftUI
import SwiftData
import SpriteKit


struct MonthYearPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    
    private var calendar: Calendar { Calendar.current }

    @State private var month: Int = 1
    @State private var year: Int = 2024

    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Picker("Month", selection: $month) {
                        ForEach(1...12, id: \.self) { m in
                            Text(calendar.monthSymbols[m-1]).tag(m)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Picker("Year", selection: $year) {
                        ForEach(2000...2100, id: \.self) { y in
                            Text(y.formatted(.number.grouping(.never)))
                        }
                    }
                    .pickerStyle(.wheel)
                }
                        .font(.title3)
                        .padding(.top, 10)
                        
                        Spacer()
                        
                            .onAppear {
                                let comps = calendar.dateComponents([.year, .month], from: selectedDate)
                                month = comps.month ?? 1
                                year = comps.year ?? 2023
                                
                            }
                }
            .navigationBarTitle("Select Month")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // 👇 this is the action closure
                        let comps = DateComponents(year: year, month: month)
                        if let newDate = calendar.date(from: comps) {
                            selectedDate = newDate
                        }
                        dismiss()
                    } label: {
                        // 👇 this is the label (what shows on screen)
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
        }
    }
}

struct GalleryView: View {
    
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]
    @Environment(\.modelContext) private var modelContext
    
    @State var month: Date
    let followDemoDate: Bool
    
    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970
    
    @State private var showMonthPicker = false
    
    @State private var jarScene: EmojiJarScene = {
        let s = EmojiJarScene(size: CGSize(width: 404, height: 420))
        s.scaleMode = .resizeFill
        return s
    }()

    
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
        return f.string(from: currentMonthStart)
    }
    
    private var canGoLeft: Bool {
        currentMonthStart > previousDemoMonthStart
    }
    
    private var canGoRight: Bool {
        currentMonthStart < demoMonthStart
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

    private func reloadJarForCurrentMonth() {
        jarScene.clearAll()
        
        for entry in monthEntries {
            jarScene.dropEmoji(entry.emoji)
        }
    }


    

    var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    
                    Color.appAccentGreen
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 35)

                    HStack {
                        Spacer()
                        
                        Button {
                            showMonthPicker = true
                        } label: {
                            HStack(spacing: 6) {
                                Text(monthTitle)
                                    .font(.system(size: 22, weight: .semibold))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    

                    ScrollView {
                        VStack(spacing: 0) {          // ← no extra spacing between jar & stats
                            
                            // 🫙 JAR WITH EMOJIS FOR THIS MONTH
                            ZStack {
                                SpriteView(scene: jarScene, options: [.allowsTransparency])
                                    .frame(width: 404, height: 400)   // ← slightly shorter jar (optional)
                            }
                            .onAppear {
                                DispatchQueue.main.async {
                                    reloadJarForCurrentMonth()
                                }
                            }

                            // STATS CARD
                            VStack(alignment: .leading, spacing: 10) {

                                Text("Statistics")
                                    .font(.system(size: 28, weight: .bold))
                                    .padding(.bottom, 4)

                                StatRow(label: "happy",     emoji: "😊", count: counts["happy"]!)
                                StatRow(label: "sad",       emoji: "😢", count: counts["sad"]!)
                                StatRow(label: "angry",     emoji: "😠", count: counts["angry"]!)
                                StatRow(label: "love",      emoji: "🥰", count: counts["love"]!)
                                StatRow(label: "calm",      emoji: "😌", count: counts["calm"]!)
                                StatRow(label: "fear",      emoji: "😨", count: counts["fear"]!)
                                StatRow(label: "disgusted", emoji: "🤢", count: counts["disgusted"]!)

                                if let best = dominant {
                                    StatRow(label: "Most: \(best.0)", emoji: best.2, count: best.1)
                                        .padding(.top, 8)
                                }
                            }
                            .padding(20)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                            .padding(.horizontal, 24)
                            .padding(.top, -8)          // ← pulls the stats card up closer to the jar
                        }
                        .padding(.bottom, 20)
                    }

                }
                .background(Color(red: 0.96, green: 0.99, blue: 0.97))
                .onAppear {
                    syncIfNeeded()
                    reloadJarForCurrentMonth()
                }
                .onChange(of: demoCurrentDate) { _ in
                    syncIfNeeded()
                    reloadJarForCurrentMonth()
                }
                .onChange(of: month) { _ in
                    reloadJarForCurrentMonth()
                }
                .navigationBarTitle("Gallery")
                .toolbarTitleDisplayMode(.inlineLarge)
                
                // ---------------------------------------------------------
                // MARK: Sheet for Month Picker
                // ---------------------------------------------------------
                .sheet(isPresented: $showMonthPicker) {
                    MonthYearPicker(selectedDate: $month)
                        .presentationDetents([.height(350)])
                }
            }
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
            Spacer()

            Text("\(count)")
                .font(.system(size: 24, weight: .bold))
                .frame(width: 40)
        }
    }
}

#Preview {
    GalleryView(month: Date(), followDemoDate: true)
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

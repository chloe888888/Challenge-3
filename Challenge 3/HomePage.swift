//
//  HomePage.swift
//

import SwiftUI
import SpriteKit
import SwiftData

struct HomePage: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970
    @AppStorage("jarBucks") private var jarBucks: Int = 100
    @AppStorage("selectedDecoration") private var selectedDecoration: Int = 1

    private var calendar: Calendar { .current }
    private var currentDate: Date { Date(timeIntervalSince1970: demoCurrentDate) }
    @State private var selectedDate: Date = Date()

    @State private var selectedEmoji: String = ""
    @State private var hasEntryForSelectedDay: Bool = false
    @State private var showEmojiPicker = false

    @State private var jarScene: EmojiJarScene = {
        let s = EmojiJarScene(size: CGSize(width: 404, height: 420))
        s.scaleMode = .resizeFill
        return s
    }()

    @State private var lastRenderedMonthStart: Date? = nil

    private var demoMonthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }
    private var previousDemoMonthStart: Date {
        calendar.date(byAdding: .month, value: -1, to: demoMonthStart)!
    }

    private var dateRange: ClosedRange<Date> {
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: demoMonthStart)!
        return previousDemoMonthStart ... min(currentDate, endOfMonth)
    }

    private var monthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
    }

    private func refreshJar(force: Bool) {
        let monthEntries = entries.filter { calendar.isDate($0.date, equalTo: monthStart, toGranularity: .month) }

        if force || lastRenderedMonthStart == nil || !calendar.isDate(lastRenderedMonthStart!, equalTo: monthStart, toGranularity: .month) {
            jarScene.clearAll()
            for e in monthEntries { jarScene.dropEmoji(e.emoji) }
            lastRenderedMonthStart = monthStart
        }

        if let matchDay = monthEntries.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
            selectedEmoji = matchDay.emoji
            hasEntryForSelectedDay = true
        } else {
            selectedEmoji = ""
            hasEntryForSelectedDay = false
        }
    }

    private func saveEmoji() {
        guard !selectedEmoji.isEmpty else { return }

        if let existing = entries.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
            let old = existing.emoji
            existing.emoji = selectedEmoji
            try? modelContext.save()
            jarScene.updateEmoji(from: old, to: selectedEmoji)

        } else {
            let new = MoodEntry(date: selectedDate, emoji: selectedEmoji)
            modelContext.insert(new)
            jarBucks += 5
            try? modelContext.save()
            jarScene.dropEmoji(selectedEmoji)
        }

        // 🔥 ALWAYS update the jar model
        let monthEntries = entries.filter { calendar.isDate($0.date, equalTo: monthStart, toGranularity: .month) }
        modelContext.createOrUpdateMonthlyJar(for: monthStart, entries: monthEntries)

        // 🔥 Also update PREVIOUS month if needed
        if monthStart < demoMonthStart {
            let pm = previousDemoMonthStart
            let prevEntries = entries.filter { calendar.isDate($0.date, equalTo: pm, toGranularity: .month) }
            if !prevEntries.isEmpty {
                modelContext.createOrUpdateMonthlyJar(for: pm, entries: prevEntries)
            }
        }

        refreshJar(force: false)
    }


    // MARK: - UI
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
              //  Color(red: 0.95, green: 0.99, blue: 0.97)
                 //   .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // HEADER
                    VStack {
                        HStack {
                            DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                            
                            Text(selectedEmoji.isEmpty ? "😶" : selectedEmoji)
                                .font(.system(size: 28))
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(Color.white.opacity(0.6)))
                            
                            Spacer()
                            
                            Text("𝐉 \(jarBucks)")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 15)
                                .background(Capsule().fill(Color.white))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color.appAccentGreen)
                    
                    // EMOJI BUTTONS
                    HStack(spacing: 12) {
                        
                        Button {
                            showEmojiPicker = true
                        } label: {
                            HStack(spacing: 8) {
                                Text(hasEntryForSelectedDay ? "Edit emoji" : "Pick emoji")
                                Text(selectedEmoji.isEmpty ? "😀" : selectedEmoji)
                            }
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.green.opacity(0.9))             // TEXT COLOR
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill (Color.white)
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green, lineWidth: 2)
                                    // BACKGROUND
                                }
                            )
                        }
                        .buttonStyle(.plain)
                        
                        
                        Button { saveEmoji() } label: {
                            HStack {
                                Image(systemName: hasEntryForSelectedDay ? "checkmark.circle" : "arrow.down.circle")
                                Text(hasEntryForSelectedDay ? "Save" : "Drop")
                            }
                            .padding(.horizontal, 39)
                            .padding(.vertical, 10)
                            .background(
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedEmoji.isEmpty ? Color.gray.opacity(0.25) : Color.white)
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedEmoji.isEmpty ? Color.gray.opacity(0.5) : Color.blue, lineWidth: 2)
                                }
                                )
                        }
                        .disabled(selectedEmoji.isEmpty)
                    }
                    .padding(.top, 20)
                    
                    // JAR + DECORATIONS
                    ZStack {
                        SpriteView(scene: jarScene, options: [.allowsTransparency])
                            .frame(width: 404, height: 420)
                        
                        DecorationOverlay(selectedDecoration: selectedDecoration)
                    }
                }
            }
            .onAppear { refreshJar(force: true) }
            .onChange(of: selectedDate) { _ in refreshJar(force: false) }
            .fullScreenCover(isPresented: $showEmojiPicker){
                EmojiPicker(selectedEmoji: $selectedEmoji, isPresented: $showEmojiPicker)
            }
            .navigationTitle("How are you feeling?")
        }
    }
}

// Overlay decorations unchanged
struct DecorationOverlay: View {
    let selectedDecoration: Int
    var body: some View {
        GeometryReader { geo in
            switch selectedDecoration {
            case 1:
                Image("Decor_1").resizable()
                    .frame(maxWidth: 220, maxHeight: 250)
                    .position(x: geo.size.width*0.86, y: geo.size.height*0.46)
                Image("Decor_1.2").resizable()
                    .frame(maxWidth: 220, maxHeight: 250)
                    .position(x: geo.size.width*0.13, y: geo.size.height*0.46)
            default:
                EmptyView()
            }
        }
    }
}
#Preview{
    HomePage()
}

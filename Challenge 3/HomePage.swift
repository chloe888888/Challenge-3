

import SwiftUI
import SpriteKit
import SwiftData

private let faceEmojis: [String] = [
    // 1️⃣ HAPPY
    "😀","😃","😄","😁","😆","😅","😂","🤣",
    "🙂","🙃","😉","😊","😇","🤠","😎","🤡",
    "😏","😜","😝","😛","🤪","🥴","🤭",

    // 2️⃣ SAD
    "😞","😔","😟","🙁","☹️","😣","😖","😫","😩",
    "🥺","🥹","😢","😭","😥","😓","😕","😶‍🌫️","😦","😧",

    // 3️⃣ ANGRY
    "😤","😠","😡","🤬","😒","🙄","🤨","😬",

    // 4️⃣ LOVE
    "🥰","😍","🤩","😘","😗","☺️","😙","😚","🤗",

    // 5️⃣ CALM
    "😶","😴","😪","😮‍💨","😌","🫥","😑","😐","🫤","🤔","😯","😮","😲",

    // 6️⃣ FEAR
    "😱","😨","😰","😳","😵","😵‍💫","🫢","🫣","🤐","🤫","🧐","🫨",

    // 7️⃣ DISGUSTED
    "🤢","🤮","🤧","🤥"
]

// For computing dominantCategory when we auto-create a MonthlyJar
private let happyEmojisSet: Set<String> = [
    "😀","😃","😄","😁","😆","😅","😂","🤣",
    "🙂","🙃","😉","😊","😇","🤠","😎","🤡",
    "😏","😜","😝","😛","🤪","🥴","🤭"
]

private let sadEmojisSet: Set<String> = [
    "😞","😔","😟","🙁","☹️","😣","😖","😫","😩",
    "🥺","🥹","😢","😭","😥","😓","😕","😶‍🌫️","😦","😧"
]

private let angryEmojisSet: Set<String> = [
    "😤","😠","😡","🤬","😒","🙄","🤨","😬"
]

private let loveEmojisSet: Set<String> = [
    "🥰","😍","🤩","😘","😗","☺️","😙","😚","🤗"
]

private let calmEmojisSet: Set<String> = [
    "😶","😴","😪","😮‍💨","😌","🫥","😑","😐","🫤","🤔","😯","😮","😲"
]

private let fearEmojisSet: Set<String> = [
    "😱","😨","😰","😳","😵","😵‍💫","🫢","🫣","🤐","🤫","🧐","🫨"
]

private let disgustedEmojisSet: Set<String> = [
    "🤢","🤮","🤧","🤥"
]



struct HomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]
    
    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970
    @AppStorage("jarBucks") private var jarBucks: Int = 100
    
    private var currentDate: Date {
        Date(timeIntervalSince1970: demoCurrentDate)
    }
    
    @State private var selectedDate: Date = Date()
    
    @State private var selectedEmoji: String = ""
    @State private var hasEntryForSelectedDay: Bool = false
    @State private var showEmojiPicker = false
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        
        let today = currentDate
        
        
        let endOfDemoMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: demoMonthStart
        ) ?? demoMonthStart
        
        
        let upper = min(today, endOfDemoMonth)
        
        
        let lower = previousDemoMonthStart
        
        return lower ... upper
    }


    
    @State private var jarScene: EmojiJarScene = {
        let scene = EmojiJarScene(size: CGSize(width: 404, height: 420))
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @AppStorage("selectedDecoration") private var selectedDecoration: Int = 1
    @State private var lastRenderedMonthStart: Date? = nil
    
    private var calendar: Calendar { Calendar.current }
    
    private var demoMonthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) ?? currentDate
    }

    
    private var previousDemoMonthStart: Date {
        calendar.date(byAdding: .month, value: -1, to: demoMonthStart) ?? demoMonthStart
    }

    
    
    private var currentMonthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) ?? selectedDate
    }

    
    private var endOfCurrentMonth: Date {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: currentMonthStart) ?? currentMonthStart
    }
    
    private var today: Date {
        let cal = Calendar.current
        return cal.startOfDay(for: Date())
    }

    private var maxSelectableDate: Date {
        
        let cal = Calendar.current
        
        if cal.isDate(selectedDate, equalTo: today, toGranularity: .month) {
            return today
        } else {
            
            let range = cal.range(of: .day, in: .month, for: selectedDate)!
            return cal.date(
                bySetting: .day,
                value: range.count,
                of: selectedDate
            )!
        }
    }
    

    
    private var formattedSelectedDate: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f.string(from: selectedDate)
    }
    
    private var headerEmoji: String {
        hasEntryForSelectedDay ? selectedEmoji : "😶"
        
    }
    
    private func refreshForSelection(forceJarRebuild: Bool) {
        let monthStart = currentMonthStart
        
        let monthEntries = entries.filter {
            calendar.isDate($0.date, equalTo: monthStart, toGranularity: .month)
        }
        
        if let entry = monthEntries.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
            hasEntryForSelectedDay = true
            selectedEmoji = entry.emoji
        } else {
            hasEntryForSelectedDay = false
            selectedEmoji = ""
        }
        
        if forceJarRebuild ||
            lastRenderedMonthStart == nil ||
            !calendar.isDate(lastRenderedMonthStart!, equalTo: monthStart, toGranularity: .month) {
            
            jarScene.clearAll()
            for entry in monthEntries {
                jarScene.dropEmoji(entry.emoji)
            }
            lastRenderedMonthStart = monthStart
            
            
        }
    }
    
    private func ensureJarForPreviousMonthIfNeeded(for date: Date) {
        let cal = calendar
        
        
        guard let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: date)) else { return }
        
        
        guard monthStart < demoMonthStart else { return }
        
        
        let existingJars = (try? modelContext.fetch(FetchDescriptor<MonthlyJar>())) ?? []
        if existingJars.contains(where: { cal.isDate($0.month, equalTo: monthStart, toGranularity: .month) }) {
            return
        }
        
        
        let monthEntries = entries.filter {
            cal.isDate($0.date, equalTo: monthStart, toGranularity: .month)
        }
        guard !monthEntries.isEmpty else { return }
        
        
        var counts: [String: Int] = [
            "happy": 0, "sad": 0, "angry": 0,
            "love": 0, "calm": 0, "fear": 0, "disgusted": 0
        ]
        
        for entry in monthEntries {
            let e = entry.emoji
            if happyEmojisSet.contains(e)      { counts["happy"]! += 1 }
            else if sadEmojisSet.contains(e)   { counts["sad"]! += 1 }
            else if angryEmojisSet.contains(e) { counts["angry"]! += 1 }
            else if loveEmojisSet.contains(e)  { counts["love"]! += 1 }
            else if calmEmojisSet.contains(e)  { counts["calm"]! += 1 }
            else if fearEmojisSet.contains(e)  { counts["fear"]! += 1 }
            else if disgustedEmojisSet.contains(e) { counts["disgusted"]! += 1 }
        }
        
        let dominant = counts.max { $0.value < $1.value }?.key ?? "happy"
        
        
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        let label = f.string(from: monthStart).uppercased()
        
        
        let jar = MonthlyJar(month: monthStart, label: label, dominantCategory: dominant)
        modelContext.insert(jar)
        try? modelContext.save()
    }

    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(red: 0.95, green: 0.99, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center, spacing: 16) {
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                in: dateRange,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            
                            Text(headerEmoji)
                                .font(.system(size: 28))
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.6))
                                )
                            
                            Spacer()
                            
                            Text("$\(jarBucks)")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                        .shadow(radius: 5)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.appAccentGreen)

                    VStack(spacing: 12) {
                        Text("What face emoji describes how you feel??")
                            .font(.system(size: 18, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        Button {
                            showEmojiPicker = true
                        } label: {
                            HStack(spacing: 8) {
                                Text(hasEntryForSelectedDay ? "Edit emoji" : "Pick emoji")
                                    .font(.system(size: 18))
                                Text(selectedEmoji.isEmpty ? "😀" : selectedEmoji)
                                    .font(.system(size: 22))
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.appAccentGreen, in: RoundedRectangle(cornerRadius: 12))
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                            
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            guard !selectedEmoji.isEmpty else { return }
                            
                            if let existing = entries.first(where: {
                                calendar.isDate($0.date, inSameDayAs: selectedDate)
                            }) {

                                let oldEmoji = existing.emoji
                                existing.emoji = selectedEmoji
                                try? modelContext.save()
                                
                                
                                jarScene.updateEmoji(from: oldEmoji, to: selectedEmoji)
                                
                            } else {
                                
                                let entry = MoodEntry(date: selectedDate, emoji: selectedEmoji)
                                modelContext.insert(entry)
                                jarBucks += 5
                                try? modelContext.save()
                                
                                
                                jarScene.dropEmoji(selectedEmoji)
                                
                                
                                ensureJarForPreviousMonthIfNeeded(for: selectedDate)
                            }

                            
                            hasEntryForSelectedDay = true
                            
                            refreshForSelection(forceJarRebuild: false)
                        } label: {
                            HStack(spacing: 8) {
                                Text(hasEntryForSelectedDay ? "Save emoji" : "Drop emoji")
                                    .font(.system(size: 18, weight: .semibold))
                                Text(selectedEmoji.isEmpty ? "🙂" : selectedEmoji)
                                    .font(.system(size: 24))
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(selectedEmoji.isEmpty
                                          ? Color.gray.opacity(0.25)
                                          : Color.white)
                            )
                            .foregroundColor(.black)
                            .shadow(color: .black.opacity(selectedEmoji.isEmpty ? 0 : 0.08),
                                    radius: 4, x: 0, y: 2)
                        }
                        .disabled(selectedEmoji.isEmpty)
                        .buttonStyle(.plain)

                        .buttonStyle(.plain)
                        .disabled(selectedEmoji.isEmpty)
                    }
                    .padding(.top, 20)
                    
                    
                    ZStack {
                        SpriteView(scene: jarScene, options: [.allowsTransparency])
                            .frame(width: 404, height: 420)
                        
                        GeometryReader { geometry in
                            Group {
                                switch selectedDecoration {
                                case 1:
                                    Image("Decor_1")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.86,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                    Image("Decor_1.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.13,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 2:
                                    Image("Decor_2.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.85,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                    Image("Decor_2.3")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.10,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 3:
                                    Image("Decor_3.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.86,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                    Image("Decor_3.3")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.13,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 4:
                                    Image("Decor_4.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.85,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                        .rotationEffect(.degrees(3))
                                    Image("Decor_4.3")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.15,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                        .rotationEffect(.degrees(-3))
                                case 5:
                                    Image("Decor_5.3")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.83,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                        .rotationEffect(.degrees(3))
                                    Image("Decor_5.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.16,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                        .rotationEffect(.degrees(-3))
                                case 6:
                                    Image("Decor_6")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.86,
                                            y: geometry.size.height * 0.53
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 7:
                                    Image("Decor_7.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.87,
                                            y: geometry.size.height * 0.48
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                    Image("Decor_7.3")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.13,
                                            y: geometry.size.height * 0.46
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 8:
                                    Image("Decor_8.2")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.84,
                                            y: geometry.size.height * 0.53
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                    Image("Decor_8.3")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.15,
                                            y: geometry.size.height * 0.53
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 9:
                                    Image("Decor 9")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.86,
                                            y: geometry.size.height * 0.50
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 10:
                                    Image("Decor 10")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.80,
                                            y: geometry.size.height * 0.75
                                        )
                                        .frame(maxWidth: 220, maxHeight: 250)
                                case 11:
                                    Image("Decor 11")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.23,
                                            y: geometry.size.height * 0.35
                                        )
                                        .frame(maxWidth: 100, maxHeight: 100)
                                case 12:
                                    Image("Decor 12")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.23,
                                            y: geometry.size.height * 0.65
                                        )
                                        .frame(maxWidth: 150, maxHeight: 150)
                                case 13:
                                    Image("Decor 13")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.50,
                                            y: geometry.size.height * 0.84
                                        )
                                        .frame(maxWidth: 150, maxHeight: 150)
                                case 14:
                                    Image("Decor 14")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.78,
                                            y: geometry.size.height * 0.33
                                        )
                                        .frame(maxWidth: 150, maxHeight: 150)
                                case 15:
                                    Image("Decor 15")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.20,
                                            y: geometry.size.height * 0.72
                                        )
                                        .frame(maxWidth: 150, maxHeight: 150)
                                case 16:
                                    Image("Decor 16")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.25,
                                            y: geometry.size.height * 0.74
                                        )
                                        .frame(maxWidth: 160, maxHeight: 170)
                                case 17:
                                    Image("Decor 17")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.86,
                                            y: geometry.size.height * 0.32
                                        )
                                        .frame(maxWidth: 140, maxHeight: 150)
                                case 18:
                                    Image("Decor 18")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.74,
                                            y: geometry.size.height * 0.74
                                        )
                                        .frame(maxWidth: 170, maxHeight: 170)
                                case 19:
                                    Image("Decor 19")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.76,
                                            y: geometry.size.height * 0.74
                                        )
                                        .frame(maxWidth: 170, maxHeight: 170)
                                case 20:
                                    Image("Decor 20")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.25,
                                            y: geometry.size.height * 0.76
                                        )
                                        .frame(maxWidth: 120, maxHeight: 130)
                                case 21:
                                    Image("Decor 21")
                                        .resizable()
                                        .position(
                                            x: geometry.size.width * 0.40,
                                            y: geometry.size.height * 0.76
                                        )
                                        .frame(maxWidth: 170, maxHeight: 120)
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .frame(width: 404, height: 420)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 16)
                }
            }
            .fullScreenCover(isPresented: $showEmojiPicker) {
                EmojiGridPicker(selection: $selectedEmoji) { emoji in
                    selectedEmoji = emoji
                }
                .interactiveDismissDisabled(true)
            }
            .onAppear {
                selectedDate = currentDate
                
                if lastRenderedMonthStart == nil {
                    refreshForSelection(forceJarRebuild: true)
                } else {
                    refreshForSelection(forceJarRebuild: false)
                }
            }
            .onChange(of: entries) { _ in
                
                refreshForSelection(forceJarRebuild: false)
            }
            .onChange(of: demoCurrentDate) { _ in
                selectedDate = currentDate
                lastRenderedMonthStart = nil
                refreshForSelection(forceJarRebuild: true)
            }
            .onChange(of: selectedDate) { _ in
                refreshForSelection(forceJarRebuild: false)
            }
            .navigationBarTitle("How are you feeling?")
        }
    }
}


struct EmojiGridPicker: View {
    @Binding var selection: String
    var onSelect: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    private let columns = [GridItem(.adaptive(minimum: 56), spacing: 8)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(faceEmojis, id: \.self) { emoji in
                        Button {
                            selection = emoji
                            onSelect(emoji)
                            dismiss()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(emoji == selection ? Color.appAccentGreen.opacity(0.3) : .clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(emoji == selection ? Color.appAccentGreen : .gray.opacity(0.2),
                                                    lineWidth: 1)
                                    )
                                Text(emoji)
                                    .font(.system(size: 32))
                            }
                            .frame(width: 56, height: 56)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Choose an Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HomePage()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

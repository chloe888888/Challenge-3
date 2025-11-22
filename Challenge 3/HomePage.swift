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
        // nothing selected → do nothing
        guard !selectedEmoji.isEmpty else { return }

        if let existing = entries.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
            // update existing entry
            let old = existing.emoji
            existing.emoji = selectedEmoji
            try? modelContext.save()
            jarScene.updateEmoji(from: old, to: selectedEmoji)

        } else {
            // create new entry
            let new = MoodEntry(date: selectedDate, emoji: selectedEmoji)
            modelContext.insert(new)

            // ✅ only give JarBucks if it's "today" (demo current date)
            if calendar.isDate(selectedDate, inSameDayAs: currentDate) {
                jarBucks += 5
            }

            try? modelContext.save()
            jarScene.dropEmoji(selectedEmoji)
        }

        // update monthly jar model
        let monthEntries = entries.filter { calendar.isDate($0.date, equalTo: monthStart, toGranularity: .month) }
        modelContext.createOrUpdateMonthlyJar(for: monthStart, entries: monthEntries)

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
                Color.appAccentGreen
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 35)

                VStack(spacing: 0) {
                    Spacer()
                    HStack(spacing: 12) {
                        Button {
                            showEmojiPicker = true
                        } label: {
                            HStack(spacing: 8) {
                                Text(hasEntryForSelectedDay ? "Edit emoji" : "Pick emoji")
                                Text(selectedEmoji.isEmpty ? "😀" : selectedEmoji)
                            }
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.green.opacity(0.9))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green, lineWidth: 2)
                                }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 70)

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
            // 👇 when the picker closes (tick tapped), auto-save & drop ball
            .onChange(of: showEmojiPicker) { isShowing in
                if !isShowing {
                    saveEmoji()
                }
            }
            .fullScreenCover(isPresented: $showEmojiPicker) {
                EmojiPicker(selectedEmoji: $selectedEmoji, isPresented: $showEmojiPicker)
            }
            .navigationTitle("How are you feeling?")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        in: dateRange,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 6) {

                        Text("𝐉")
                            .font(.system(size: 18, weight: .bold))
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color.yellow)
                            )

                        Text("\(jarBucks)")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(Capsule().fill(Color.white))
                    .frame(width: 110)
                }
            }
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
                Image("Decor_5.3").resizable()
                    .frame(maxWidth: 220, maxHeight: 250)
                    .position(x: geo.size.width*0.83, y: geo.size.height*0.50)
                    .rotationEffect(.degrees(3))
                Image("Decor_5.2").resizable()
                    .frame(maxWidth: 220, maxHeight: 250)
                    .position(x: geo.size.width*0.16, y: geo.size.height*0.50)
                    .rotationEffect(.degrees(-3))
            // ... your other cases stay the same ...
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    HomePage()
}

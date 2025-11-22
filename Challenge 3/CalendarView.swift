import SwiftUI
import SwiftData
import UIKit

// -------------------------------------------------------
// MARK: - MAIN CALENDAR VIEW
// -------------------------------------------------------

struct CalendarView: View {
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    @State private var selectedDate = Date()

    private let cal = Calendar.current

    // Convert entries → [Date: Emoji]
    private var emojiByDate: [Date: String] {
        var map: [Date: String] = [:]

        for entry in entries {
            let day = cal.startOfDay(for: entry.date)
            map[day] = entry.emoji
        }
        return map
    }

    private var selectedEmoji: String? {
        emojiByDate[cal.startOfDay(for: selectedDate)]
    }

    private var monthTitle: String {
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        return df.string(from: selectedDate)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Color.appAccentGreen
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 35)
                    
                // HEADER
    

                // BUILT-IN APPLE CALENDAR
                CalendarMonthView(
                    selectedDate: $selectedDate,
                    emojiByDate: emojiByDate
                )
                .frame(height: 420)
                .padding(.top, 16)
                // SELECTED-DAY DETAILS
                if let emoji = selectedEmoji {
                    Text("Your mood on this day: \(emoji)")
                        .font(.title3)
                        .padding(.top, 12)
                } else {
                    Text("No emoji saved for this day.")
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                }

                Spacer()
            }
            .background(Color(red: 0.95, green: 0.99, blue: 0.97))
            .navigationBarTitle("Calendar")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}


// -------------------------------------------------------
// MARK: - UIKit Calendar Wrapper (Inside Same File!)
// -------------------------------------------------------

struct EmojiCalendarUIKit: UIViewRepresentable {

    @Binding var selectedDate: Date
    let emojiByDate: [Date: String]
    let cal = Calendar.current

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = .current
        view.fontDesign = .default   // IMPORTANT

        view.delegate = context.coordinator
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)

        view.availableDateRange = DateInterval(start: .distantPast, end: Date())

        return view
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Reload ALL emoji days
        let dates = emojiByDate.keys.map {
            cal.dateComponents([.year, .month, .day], from: $0)
        }
        uiView.reloadDecorations(forDateComponents: dates, animated: false)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

        let parent: EmojiCalendarUIKit
        let cal = Calendar.current

        init(parent: EmojiCalendarUIKit) {
            self.parent = parent
        }

        func calendarView(
            _ calendarView: UICalendarView,
            decorationFor dateComponents: DateComponents
        ) -> UICalendarView.Decoration? {

            guard let date = dateComponents.date else { return nil }

            if let emoji = parent.emojiByDate.first(where: {
                cal.isDate($0.key, inSameDayAs: date)
            })?.value {

                return .customView {
                    let label = UILabel()
                    label.text = emoji
                    label.font = .systemFont(ofSize: 16)
                    label.textAlignment = .center
                    return label
                }
            }

            return nil
        }

        func dateSelection(
            _ selection: UICalendarSelectionSingleDate,
            didSelectDate dateComponents: DateComponents?
        ) {
            if let date = dateComponents?.date {
                parent.selectedDate = date
            }
        }
    }
}
#Preview{
    CalendarView()
}

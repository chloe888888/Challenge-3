import SwiftUI
import SwiftData
import UIKit


struct CalendarView: View {
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    @State private var selectedDate = Date()

    private let cal = Calendar.current


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
                    

                EmojiCalendarUIKit(
                    selectedDate: $selectedDate,
                    emojiByDate: emojiByDate
                )
                .frame(height: 450)
                .padding(.horizontal)
                .padding(.top, 16)

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




struct EmojiCalendarUIKit: UIViewRepresentable {

    @Binding var selectedDate: Date
    let emojiByDate: [Date: String]
    let cal = Calendar.current

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator


        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)


        view.availableDateRange = DateInterval(start: .distantPast, end: Date())

        return view
    }

    func updateUIView(_ uiView:
                      UICalendarView, context: Context){
        uiView.reloadDecorations(forDateComponents: [], animated: false)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject,
                       UICalendarViewDelegate,
                       UICalendarSelectionSingleDateDelegate {

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

                let label = UILabel()
                label.text = emoji
                label.font = UIFont.systemFont(ofSize: 18)
                label.textAlignment = .center

                return .customView {
                    let container = UIView()

                    let number = UILabel()
                    let emojiLabel = UILabel()

 
                    let day = Calendar.current.component(.day, from: date)
                    number.text = "\(day)"
                    number.font = UIFont.systemFont(ofSize: 9)


                    emojiLabel.text = emoji
                    emojiLabel.font = UIFont.systemFont(ofSize: 16)

                    number.translatesAutoresizingMaskIntoConstraints = false
                    emojiLabel.translatesAutoresizingMaskIntoConstraints = false

                    container.addSubview(number)
                    container.addSubview(emojiLabel)

                    NSLayoutConstraint.activate([
                        number.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                        number.topAnchor.constraint(equalTo: container.topAnchor, constant: 3),

                        emojiLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                        emojiLabel.topAnchor.constraint(equalTo: number.bottomAnchor, constant: -1)
                    ])

                    return container
                }

            }

            return nil
        }


        func dateSelection(
            _ selection: UICalendarSelectionSingleDate,
            didSelectDate dateComponents: DateComponents?
        ) {

            guard let date = dateComponents?.date else { return }
            parent.selectedDate = date
        }
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

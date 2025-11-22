//
//  CalendarMonthView.swift
//  Challenge 3
//
//  Created by Chloe Lin on 22/11/25.
//

import SwiftUI

struct CalendarMonthView: View {
    @Binding var selectedDate: Date
    let emojiByDate: [Date: String]

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {

        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let year = calendar.component(.year, from: monthStart)
        let month = calendar.component(.month, from: monthStart)

        let numberOfDays = calendar.range(of: .day, in: .month, for: monthStart)!.count
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1

        VStack(spacing: 12) {

            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.blue)
                }

                Spacer()

                Text(monthTitle(monthStart))
                    .font(.title3)
                    .bold()

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)

            // WEEKDAY LABELS
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day.uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            // GRID OF DAYS
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<42, id: \.self) { index in

                    let gridPosition = index - firstWeekday
                    let day = gridPosition + 1

                    if day >= 1 && day <= numberOfDays {
                        let date = calendar.date(from:
                            DateComponents(year: year, month: month, day: day)
                        )!

                        let key = calendar.startOfDay(for: date)
                        let emoji = emojiByDate[key]

                        Text(emoji ?? "\(day)")
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, minHeight: 32)
                            .foregroundColor(.primary)
                            .onTapGesture {
                                selectedDate = date
                            }

                    } else {
                        Text("")
                            .frame(maxWidth: .infinity, minHeight: 32)
                    }
                }
            }
        }
    }

    private func monthTitle(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        return df.string(from: date)
    }


    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newMonth
        }
    }
}

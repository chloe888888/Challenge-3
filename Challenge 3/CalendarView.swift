//
//  CalendarView.swift
//  Challenge 3
//
//  Created by Shivani  on 14/11/25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {

    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let calendar = Calendar.current
    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970

    var currentDate: Date {
        Date(timeIntervalSince1970: demoCurrentDate)
    }

    
    private var emojiByDay: [Int: String] {
        var dict: [Int: String] = [:]
        for entry in entries {
            if calendar.isDate(entry.date, equalTo: currentDate, toGranularity: .month),
               calendar.isDate(entry.date, equalTo: currentDate, toGranularity: .year) {
                let day = calendar.component(.day, from: entry.date)
                dict[day] = entry.emoji            }
        }
        return dict
    }
    
    var daysInMonth: [[Int?]] {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let firstOfMonth = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth)!
        let numDays = range.count
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let startingSpaces = (firstWeekday == 1) ? 6 : firstWeekday - 2
        
        var days: [[Int?]] = []
        var week: [Int?] = Array(repeating: nil, count: startingSpaces)
        
        for day in 1...numDays {
            week.append(day)
            if week.count == 7 {
                days.append(week)
                week = []
            }
        }
        
        if !week.isEmpty {
            while week.count < 7 {
                week.append(nil)
            }
            days.append(week)
        }
        
        return days
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Calendar")
                        .font(.system(size: 48, weight: .bold))
                        .fontDesign(.rounded)
                    Text(monthYearString)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                .background(Color(red: 0.7, green: 0.95, blue: 0.8))
                
                
                VStack(spacing: 0) {
                    
                    HStack(spacing: 0) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color(red: 0.5, green: 0.85, blue: 0.7), lineWidth: 2)
                                )
                        }
                    }
                    
                    ForEach(0..<daysInMonth.count, id: \.self) { weekIndex in
                        HStack(spacing: 0) {
                            ForEach(0..<7) { dayIndex in
                                let day = daysInMonth[weekIndex][dayIndex]
                                CalendarDayCell(
                                    day: day,
                                    emoji: day.flatMap { emojiByDay[$0] }
                                )
                            }
                        }
                    }
                }
                .background(Color.white)
                .padding(20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.95, green: 0.99, blue: 0.97))
        }
    }
}

struct CalendarDayCell: View {
    let day: Int?
    let emoji: String?
    
    var body: some View {
        VStack(spacing: 4) {
            if let day = day {
                Text("\(day)")
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, 8)
                    .padding(.leading, 8)
                
                if let emoji = emoji {
                    Text(emoji)
                        .font(.system(size: 28))
                        .padding(.bottom, 8)
                } else {
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .background(Color.white)
        .overlay(
            Rectangle()
                .stroke(Color(red: 0.5, green: 0.85, blue: 0.7), lineWidth: 2)
        )
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

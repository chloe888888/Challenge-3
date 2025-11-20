//
//  SettingsView.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 21/11/25.
//




import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]
    @Query(sort: \MonthlyJar.month) private var jars: [MonthlyJar]
    
    @AppStorage("jarBucks") private var jarBucks: Int = 100
    @AppStorage("demoCurrentDate") private var demoCurrentDate: Double = Date().timeIntervalSince1970
    @AppStorage("selectedDecoration") private var selectedDecoration: Int = 1
    @AppStorage("ownedDecorations") private var ownedDecorationsRaw: String = "1"
    
    @State private var deleteAll: Bool = false
    @State private var selectedMonths = Set<Date>()
    @State private var showConfirm = false
    
    private var calendar: Calendar { Calendar.current }
    

    private var availableMonths: [Date] {
        var set = Set<Date>()
        for e in entries {
            if let m = calendar.date(from: calendar.dateComponents([.year, .month], from: e.date)) {
                set.insert(m)
            }
        }
        for j in jars {
            if let m = calendar.date(from: calendar.dateComponents([.year, .month], from: j.month)) {
                set.insert(m)
            }
        }
        return set.sorted()
    }
    
    private func monthLabel(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        return f.string(from: date)
    }
    
    private func performDelete() {
        if deleteAll {
            
            entries.forEach { modelContext.delete($0) }
            jars.forEach { modelContext.delete($0) }
            

            jarBucks = 100
            demoCurrentDate = Date().timeIntervalSince1970
            selectedDecoration = 1
            ownedDecorationsRaw = "1"
        } else {
         
            for monthStart in selectedMonths {
                entries
                    .filter { calendar.isDate($0.date, equalTo: monthStart, toGranularity: .month) }
                    .forEach { modelContext.delete($0) }
                
                jars
                    .filter { calendar.isDate($0.month, equalTo: monthStart, toGranularity: .month) }
                    .forEach { modelContext.delete($0) }
            }
        }
        
        try? modelContext.save()
        selectedMonths.removeAll()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.99, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Reset data")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 16)
                    
                    Text("Choose what you want to delete from Jarmoji.")
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $deleteAll) {
                            Text("Delete everything")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .tint(Color.appAccentGreen)
                        
                        if !availableMonths.isEmpty {
                            Text("Or choose specific months:")
                                .font(.system(size: 16, weight: .medium))
                                .padding(.top, 4)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(availableMonths, id: \.self) { month in
                                        let isSelected = selectedMonths.contains(month)
                                        
                                        Button {
                                            if isSelected {
                                                selectedMonths.remove(month)
                                            } else {
                                                selectedMonths.insert(month)
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(isSelected ? .appAccentGreen : .gray)
                                                Text(monthLabel(for: month))
                                                Spacer()
                                            }
                                            .padding(.vertical, 4)
                                        }
                                        .disabled(deleteAll)
                                    }
                                }
                            }
                            .frame(maxHeight: 180)
                        } else {
                            Text("No months to delete yet.")
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    )
                    
                    Spacer()
                    
                    Button {
                        showConfirm = true
                    } label: {
                        Text("Delete")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(deleteAll || !selectedMonths.isEmpty ? Color.red.opacity(0.9) : Color.gray.opacity(0.4))
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(!deleteAll && selectedMonths.isEmpty)
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete data?",
                   isPresented: $showConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    performDelete()
                }
            } message: {
                Text(deleteAll
                     ? "This will erase all your Jarmoji history and reset your JarBucks and decorations. This cannot be undone."
                     : "This will delete all entries and jars in the selected months. This cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [MoodEntry.self, MonthlyJar.self], inMemory: true)
}

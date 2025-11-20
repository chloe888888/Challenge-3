//
//  ResetView.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 21/11/25.
//



import SwiftUI
import SwiftData

struct ResetView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \MonthlyJar.month) private var jars: [MonthlyJar]
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    @State private var selectedMonths: Set<Date> = []
    @State private var showConfirm = false

    private var monthFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        return f
    }

    private var monthGroups: [Date] {
        jars.map { $0.month }
            .sorted()
    }

    var body: some View {
        NavigationStack {
            List {

   
                Section("Delete Options") {
                    Button {
                        selectedMonths = Set(monthGroups)
                    } label: {
                        Label("Select All Months", systemImage: "checkmark.circle")
                    }

                    Button {
                        selectedMonths.removeAll()
                    } label: {
                        Label("Clear Selection", systemImage: "xmark.circle")
                    }
                }

        
                Section("Months") {
                    ForEach(monthGroups, id: \.self) { m in
                        HStack {
                            Text(monthFormatter.string(from: m))
                            Spacer()
                            Image(systemName: selectedMonths.contains(m)
                                  ? "checkmark.square.fill"
                                  : "square")
                                .onTapGesture {
                                    if selectedMonths.contains(m) {
                                        selectedMonths.remove(m)
                                    } else {
                                        selectedMonths.insert(m)
                                    }
                                }
                        }
                    }
                }

  
                Section {
                    Button(role: .destructive) {
                        showConfirm = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Selected Data")
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                    }
                    .disabled(selectedMonths.isEmpty)
                }
            }
            .navigationTitle("Settings")
            .alert("Are you sure?", isPresented: $showConfirm) {

                Button("Cancel", role: .cancel) {}

                Button("Delete", role: .destructive) {
                    deleteSelected()
                }

            } message: {
                Text("This cannot be undone.")
            }
        }
    }

    private func deleteSelected() {

        for m in selectedMonths {

      
            for e in entries where Calendar.current.isDate(e.date, equalTo: m, toGranularity: .month) {
                modelContext.delete(e)
            }

     
            if let jar = (try? modelContext.fetch(
                FetchDescriptor<MonthlyJar>(predicate: #Predicate { $0.month == m })
            ))?.first {
                modelContext.delete(jar)
            }
        }

        try? modelContext.save()
        selectedMonths.removeAll()
    }
}

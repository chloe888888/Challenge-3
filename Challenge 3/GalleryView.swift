//
//  GalleryView.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 17/11/25.
//

import SwiftUI
import SwiftData
struct GalleryView: View {
    @Query(sort: \MonthlyJar.month, order: .reverse) private var jars: [MonthlyJar]
    @State private var searchText = ""
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private func jarImageName(for category: String) -> String {
        switch category {
        case "happy":     return "Jar_Happy"
        case "sad":       return "Jar_Sad"
        case "angry":     return "Jar_Angry"
        case "love":      return "Jar_Love"
        case "calm":      return "Jar_calm"
        case "fear":      return "Jar_Fear"
        case "disgusted": return "Jar_Disgusted"
        default:          return "Jar_Happy"
        }
    }
    private var filteredJars: [MonthlyJar] {
        guard !searchText.isEmpty else { return jars }
        return jars.filter { jar in
            jar.label.lowercased().contains(searchText.lowercased())
        }
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.99, blue: 0.97)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    // Header
                    ZStack(alignment: .bottomLeading) {
                        Color(red: 0.7, green: 0.95, blue: 0.8)
                            .ignoresSafeArea(edges: .top)
                            .padding(.bottom, 50)
                    }
                    .frame(height: 120)
                    // Search + grid card
                    VStack {
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search…", text: $searchText)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        // Jars grid
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 24) {
                                ForEach(filteredJars) { jar in
                                    NavigationLink {
                                        StatisticsView(month: jar.month)
                                    } label: {
                                        VStack(spacing: 6) {
                                            Image(jarImageName(for: jar.dominantCategory))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                            Text(jar.label)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        }
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 0.7, green: 0.95, blue: 0.8), lineWidth: 3)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 50)
                    Spacer()
                }
            }
            .navigationBarTitle("Gallery")
        }
    }
}
#Preview {
    GalleryView()
        .modelContainer(for: [MoodEntry.self, MonthlyJar.self], inMemory: true)
}


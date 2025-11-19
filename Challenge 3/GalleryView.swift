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
        case "happy":     return "jar_happy"
        case "sad":       return "jar_sad"
        case "angry":     return "jar_angry"
        case "love":      return "jar_love"
        case "calm":      return "jar_calm"
        case "fear":      return "jar_fear"
        case "disgusted": return "jar_disgusted"
        default:          return "jar_happy"
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
                    ZStack(alignment: .bottomLeading) {
                        Color(red: 0.7, green: 0.95, blue: 0.8)
                            .ignoresSafeArea(edges: .top)
                        
                        Text("Gallery of Jar")
                            .font(.system(size: 36, weight: .bold))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 14)
                    }
                    .frame(height: 120)
                    
                    VStack(spacing: 16) {
                        
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
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 24) {
                                ForEach(filteredJars) { jar in
                                    NavigationLink {
                                        StatisticsView(month: jar.month)
                                    } label: {
                                        GeometryReader { geometry in
                                            VStack(spacing: 6) {
                                                ZStack {
                                                    Image(jarImageName(for: jar.dominantCategory))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 150, height: 150)
                                                        .frame(width: geometry.size.width * 0.55)
                                                        .offset(y: -geometry.size.height * 0.35)

                                                    Text(jar.label)
                                                        .font(.system(size: 20, weight: .medium))
                                                        .foregroundColor(.black)
                                                        .offset(y: geometry.size.height * 0.10)
                                                }
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                            }
                                        }
                                        .frame(height: 170)   

                                        
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
                    .padding(.top, 16)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GalleryView()
        .modelContainer(for: [MoodEntry.self, MonthlyJar.self], inMemory: true)
}

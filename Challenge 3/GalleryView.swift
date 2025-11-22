//
//  GalleryView.swift
//

import SwiftUI
import SwiftData

struct GalleryView: View {
    @State private var isNewItemSheetPresented = false

    @Query(sort: \MonthlyJar.month, order: .reverse)
    private var jars: [MonthlyJar]

    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private func jarImage(for cat: String) -> String {
        switch cat {
        case "happy": return "Jar_Happy"
        case "sad": return "Jar_Sad"
        case "angry": return "Jar_Angry"
        case "love": return "Jar_Love"
        case "calm": return "Jar_Calm"
        case "fear": return "Jar_Fear"
        case "disgusted": return "Jar_Disgust"
        default: return "Jar_Happy"
        }
    }

    private var filtered: [MonthlyJar] {
        if searchText.isEmpty { return jars }
        return jars.filter { $0.label.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.99, blue: 0.97)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // HEADER
                    ZStack(alignment: .bottomLeading) {
                        Color.appAccentGreen
                            .ignoresSafeArea(edges: .top)
                    }
                    .frame(height: 35)

                    // MAIN
                    VStack(spacing: 16) {

                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search…", text: $searchText)
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3)))
                        .padding(.horizontal, 16)
                        .padding(.top, 10)

                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 24) {
                                ForEach(filtered) { jar in
                                    NavigationLink {
                                        StatisticsView(
                                            month: jar.month,
                                            followDemoDate: false
                                        )
                                    } label: {
                                        VStack(spacing: 6) {
                                            Image(jarImage(for: jar.dominantCategory))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)

                                            Text(jar.label)
                                                .font(.system(size: 12))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.appAccentGreen.opacity(0.4), lineWidth: 3)
                    )
                    
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarTitle("Gallery of Jars")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                            Button {
                                isNewItemSheetPresented = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 24))
                            }
                            .sheet(isPresented: $isNewItemSheetPresented) {
                                info()
                            }
                            .foregroundStyle(.black)

                                }
        }
    }
}
#Preview{
    GalleryView()
}

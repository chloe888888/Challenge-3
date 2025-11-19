//
//  HomePage.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 10/11/25.
//

import SwiftUI
import Combine
import SpriteKit
import SwiftData

// All face emojis used in the picker
private let faceEmojis: [String] = [
    // 1️⃣ Happy
    "😀","😃","😄","😁","😆","😅","😂","🤣","🙂","🙃","😉","😊","😇",
    
    // 2️⃣ Sad
    "😞","😔","😟","🙁","☹️","😣","😖","😫","😩","🥺","🥹","😢","😭","😥","😓","😕",
    
    // 3️⃣ Angry
    "😤","😠","😡","🤬","😒","🙄","😏","🤨","😑","😐","🫤","😬","🫨",
    
    // 4️⃣ Love
    "🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋",
    "😛","😝","😜","🤪","🤠","😎","🥸","🤓","🧐",
    
    // 5️⃣ Calm
    "😶","😴","😪","😮‍💨","😌","🫥",
    
    // 6️⃣ Fear
    "😱","😨","😰","😳","😵","😵‍💫","😶‍🌫️","🫢","🫣","🤐","🤫",
    
    // 7️⃣ Disgusted
    "🤢","🤮","🤧","💩","🤥","🤡"
]

struct HomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]
    
    @State private var currentDate = Date()
    @AppStorage("mojiBucks") private var mojiBucks: Int = 100
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State private var selectedEmoji: String = ""
    @State private var showEmojiPicker = false
    @State private var hasDroppedToday = false
    
    @State private var jarScene: EmojiJarScene = {
        let scene = EmojiJarScene(size: CGSize(width: 404, height: 500))
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @AppStorage("selectedDecoration") private var selectedDecoration: Int = 1
    
    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f.string(from: currentDate)
    }
    
    private func restoreJarFromHistory() {
        let calendar = Calendar.current
        
        jarScene.clearAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for entry in entries {
                jarScene.dropEmoji(entry.emoji)
            }
            
            if let todayEntry = entries.first(where: {
                calendar.isDate($0.date, inSameDayAs: currentDate)
            }) {
                hasDroppedToday = true
                selectedEmoji = todayEntry.emoji
            } else {
                hasDroppedToday = false
                selectedEmoji = ""
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("How are you feeling?")
                        .font(.system(size: 40, weight: .medium))
                        .fontDesign(.rounded)
                    
                    HStack(spacing: 24) {
                        Text(formattedDate)
                            .font(.system(size: 24, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.appAccentGreen)
                            )
                        
                        Spacer()
                        
                        Text("$\(mojiBucks)")
                            .font(.system(size: 24, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.appAccentGreen)
                            )
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 16)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity)
                .background(Color.appAccentGreen)
                
                Spacer()
            }
            
            ZStack {
                SpriteView(scene: jarScene, options: [.allowsTransparency])
                    .frame(width: 404, height: 500)
                
                GeometryReader { geometry in
                    Group {
                        switch selectedDecoration {
                        case 1:
                            Image("Decor_1")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.86,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                            Image("Decor_1.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.13,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 2:
                            Image("Decor_2.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.85,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                            Image("Decor_2.3")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.10,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 3:
                            Image("Decor_3.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.86,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                            Image("Decor_3.3")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.13,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 4:
                            Image("Decor_4.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.85,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                                .rotationEffect(.degrees(3))
                            Image("Decor_4.3")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.15,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                                .rotationEffect(.degrees(-3))
                        case 5:
                            Image("Decor_5.3")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.83,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                                .rotationEffect(.degrees(3))
                            Image("Decor_5.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.16,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                                .rotationEffect(.degrees(-3))
                        case 6:
                            Image("Decor_6")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.86,
                                    y: geometry.size.height * 0.53
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 7:
                            Image("Decor_7.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.86,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                            Image("Decor_7.3")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.13,
                                    y: geometry.size.height * 0.46
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 8:
                            Image("Decor_8.2")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.84,
                                    y: geometry.size.height * 0.53
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                            Image("Decor_8.3")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.15,
                                    y: geometry.size.height * 0.53
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 9:
                            Image("Decor 9")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.86,
                                    y: geometry.size.height * 0.50
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 10:
                            Image("Decor 10")
                                .resizable()
                                .position(
                                    x: geometry.size.width * 0.80,
                                    y: geometry.size.height * 0.75
                                )
                                .frame(maxWidth: .maximum(220, 220), maxHeight: .maximum(250, 250))
                        case 11:
                            Image("Decor 11")
                                .resizable()
                        case 12:
                            Image("Decor 12")
                                .resizable()
                        case 13:
                            Image("Decor 13")
                                .resizable()
                        case 14:
                            Image("Decor 14")
                                .resizable()
                        case 15:
                            Image("Decor 15")
                                .resizable()
                        case 16:
                            Image("Decor 16")
                                .resizable()
                        case 17:
                            Image("Decor 17")
                                .resizable()
                        case 18:
                            Image("Decor 18")
                                .resizable()
                        case 19:
                            Image("Decor 19")
                                .resizable()
                        case 20:
                            Image("Decor 20")
                                .resizable()
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .frame(width: 404, height: 500)
            .padding(.top, 220)
            
            if !hasDroppedToday {
                VStack(spacing: 16) {
                    Text("What face emoji best describes how you are feeling today?")
                        .font(.system(size: 20, weight: .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 32)
                    
                    Button {
                        showEmojiPicker = true
                    } label: {
                        HStack(spacing: 8) {
                            Text("Choose face emoji")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                            
                            Text(selectedEmoji)
                                .font(.system(size: 22))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.appAccentGreen, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        guard !selectedEmoji.isEmpty else { return }
                        
                        let entry = MoodEntry(date: currentDate, emoji: selectedEmoji)
                        modelContext.insert(entry)
                        try? modelContext.save()
                        
                        jarScene.dropEmoji(selectedEmoji)
                        hasDroppedToday = true
                    } label: {
                        Text(selectedEmoji)
                            .font(.system(size: 55))
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(.systemGray6))
                            )
                    }
                }
                .padding(.top, 190)
            }
        }
        .fullScreenCover(isPresented: $showEmojiPicker) {
            EmojiGridPicker(selection: $selectedEmoji) { emoji in
                selectedEmoji = emoji
            }
            .interactiveDismissDisabled(true)
        }
        .onReceive(timer) { _ in
            currentDate = Date()
        }
        .onAppear {
            currentDate = Date()
            restoreJarFromHistory()
        }
    }
}

struct EmojiGridPicker: View {
    @Binding var selection: String
    var onSelect: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    private let columns = [GridItem(.adaptive(minimum: 56), spacing: 8)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(faceEmojis, id: \.self) { emoji in
                        Button {
                            selection = emoji
                            onSelect(emoji)
                            dismiss()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(emoji == selection ? Color.blue.opacity(0.2) : .clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(emoji == selection ? .blue : .gray.opacity(0.2),
                                                    lineWidth: 1)
                                    )
                                Text(emoji)
                                    .font(.system(size: 32))
                            }
                            .frame(width: 56, height: 56)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Choose an Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HomePage()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

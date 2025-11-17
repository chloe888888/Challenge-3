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
    // SwiftData context + saved moods
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    // Basic state
    @State private var currentDate = Date()
    @State private var mojiBucks = 100
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    // Emoji selection & UI
    @State private var selectedEmoji: String = ""
    @State private var showEmojiPicker = false
    @State private var hasDroppedToday = false

    // SpriteKit jar
    @State private var jarScene: EmojiJarScene = {
        let scene = EmojiJarScene(size: CGSize(width: 404, height: 500))
        scene.scaleMode = .resizeFill
        return scene
    }()

    // NOTE: this is still how you’re checking decorations.
    // (Even though it doesn’t “sync” with the Decor view’s @State,
    // I’m keeping it because you’re using these flags.)
    private var decorShop = Decor()

    // MARK: - Helpers

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f.string(from: currentDate)
    }

    /// Rebuild jar from all previous MoodEntry rows, and detect if today already has one.
    private func restoreJarFromHistory() {
        let calendar = Calendar.current

        jarScene.clearAll()

        // tiny delay so SpriteKit has its size
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

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()

            // ===== Header (green bar with title + date/money) =====
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("How are you feeling?")
                        .font(.system(size: 40, weight: .medium))
                        .fontDesign(.rounded)

                    HStack(spacing: 24) {
                        // Date capsule
                        Text(formattedDate)
                            .font(.system(size: 24, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.appAccentGreen)
                            )

                        Spacer()

                        // Money capsule
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

            // ===== Jar (SpriteKit) =====
            SpriteView(scene: jarScene, options: [.allowsTransparency])
                .frame(width: 404, height: 500)
                .padding(.top, 220)   // push it under the header

            // ===== Controls + decorations (only before dropping today’s ball) =====
            if !hasDroppedToday {
                VStack(spacing: 16) {
                    Text("What face emoji best describes how you are feeling today:")
                           .font(.system(size: 18, weight: .medium))
                           .multilineTextAlignment(.center)
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

                    // drop button (big emoji)
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
                            .background(Color(.systemGray6),
                                        in: RoundedRectangle(cornerRadius: 100))
                    }

                    // decorations, same conditions you already had
                    Group {
                        if decorShop.decoration1Clicked {
                            Image("Decor_1")
                        } else if decorShop.decoration2Clicked {
                            Image("Decor_2")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -120, y: 30)
                        } else if decorShop.decoration3Clicked {
                            Image("Decor_3")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -130, y: -25)
                                .rotationEffect(.degrees(-25))
                        } else if decorShop.decoration4Clicked {
                            Image("Decor_4.2")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -120, y: 30)
                            Image("Decor_4.3")
                        } else if decorShop.decoration5Clicked {
                            Image("Decor_5.2")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -120, y: 30)
                            Image("Decor_5.3")
                        } else if decorShop.decoration6Clicked {
                            Image("Decor_6.2")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -120, y: 30)
                            Image("Decor_6.3")
                        } else if decorShop.decoration7Clicked {
                            Image("Decor_7.2")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -120, y: 30)
                            Image("Decor_7.3")
                        } else if decorShop.decoration8Clicked {
                            Image("Decor_8.2")
                                .resizable()
                                .frame(width: 140, height: 140)
                                .offset(x: -120, y: 30)
                            Image("Decor_8.3")
                        }
                    }
                }
                .padding(.top, 190)   // position the text/buttons under the header
            }
        }
        // ===== Modifiers attached to the ROOT view (no more `Any` error) =====
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

// MARK: - Emoji picker sheet

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

// MARK: - Preview

#Preview {
    HomePage()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}

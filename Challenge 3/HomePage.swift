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

private let faceEmojis: [String] = [
    //1️⃣ Happy
    "😀","😃","😄","😁","😆","😅","😂","🤣","🙂","🙃","😉","😊","😇",
    //2️⃣ Sad
    "😞","😔","😟","🙁","☹️","😣","😖","😫","😩","🥺","🥹","😢","😭","😥","😓","😕",
    //3️⃣ Angry
    "😤","😠","😡","🤬","😒","🙄","😏","🤨","😑","😐","🫤","😬","🫨",
    //4️⃣ Afraid
    "😱","😨","😰","😳","😵","😵‍💫","😶‍🌫️","🫢","🫣","🤐","🤫",
    //5️⃣ Disgusted
    "🤢","🤮","🤧","💩","🤥","🤡",
    //6️⃣ Surprised
    "😯","😲","🤯","😮",
    //7️⃣ Excited
    "🥰","😍","🤩","😘","😗","☺️","😙","😚","🥲","🤗","😋","😛","😝","😜","🤪","🤠","😎","🥸","🤓","🧐",
    //8️⃣ Neutral
    "😶","😴","😪","😮‍💨","😌","🫥",
    //9️⃣ Tired
    "🥱","🤒","🤕","🥵","🥶"
]

struct HomePage: View {
    // SwiftData context to save moods
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date) private var entries: [MoodEntry]

    @State private var currentDate = Date()
    @State private var mojiBucks = 100
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State private var selectedEmoji: String = ""
    @State private var showEmojiPicker = false
    @State private var hasDroppedToday = false


    @State private var jarScene: EmojiJarScene = {
        let scene = EmojiJarScene(size: CGSize(width: 404, height: 500))
        scene.scaleMode = .resizeFill
        return scene
    }()
    
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
        ZStack {

            Rectangle()
                .fill(Color.appAccentGreen)
                .frame(width: 404, height: 100)
                .offset(y: -350)
            
            Text("How are you feeling?")
                .font(.system(size: 40, weight: .medium))
                .offset(y: -355)
            
            Text(formattedDate)
                .font(.system(size: 30, weight: .medium))
                .offset(x:-100, y: -270)
            
            Text("$\(mojiBucks)")
                .font(.system(size: 30, weight: .medium))
                .offset(x:110, y: -270)
            
            Rectangle()
                .fill(Color.appAccentGreen)
                .frame(width: 404, height: 5)
                .offset(y: -240)

            SpriteView(scene: jarScene, options: [.allowsTransparency])
                .frame(width: 404, height: 500)
                .offset(y: 140)


            if !hasDroppedToday {
                Text("What face emoji best describes how you are feeling today:")
                    .font(.system(size: 24.5, weight: .medium))
                    .offset(y: -190)

                Button {
                    showEmojiPicker = true
                } label: {
                    HStack {
                        Text("Choose face emoji")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        Text(selectedEmoji)
                            .font(.system(size: 22))
                    }
                    .frame(width: 300, height: 40)
                    .background(Color.appAccentGreen, in: RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green.opacity(0.3), lineWidth: 2)
                    )
                }
                .buttonStyle(.plain)
                .offset(y:-130)
                
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
                        .offset(y: -30)
                }
            }
        }
        .fullScreenCover(isPresented: $showEmojiPicker) {
            EmojiGridPicker(selection: $selectedEmoji) { emoji in
                selectedEmoji = emoji
            }
            .interactiveDismissDisabled(true)
        }
        .onReceive(timer) { _ in currentDate = Date() }
        .onAppear {
            currentDate = Date()
            restoreJarFromHistory()   
        }
    }
}


private struct EmojiGridPicker: View {
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

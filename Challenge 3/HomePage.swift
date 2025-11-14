//
//  HomePage.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 10/11/25.
//

import SwiftUI
import Combine

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
    @State private var currentDate = Date()
    @State private var mojiBucks = 100
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State private var selectedEmoji: String = ""
    @State private var showEmojiPicker = false
    
    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f.string(from: currentDate)
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
                print("Drop emoji ball")
            } label: {
                Text(selectedEmoji)
                    .font(.system(size: 55))
                    .background(Color(.systemGray6),
                                in: RoundedRectangle(cornerRadius: 100))
                    .offset(y: -70)
            }
            Rectangle()
                .frame(width: 404, height: 600)
                .offset(y: 63)
        }
        .fullScreenCover(isPresented: $showEmojiPicker) {
            EmojiGridPicker(selection: $selectedEmoji)
                .interactiveDismissDisabled(true)
        }
        .onReceive(timer) { _ in currentDate = Date() }
        .onAppear { currentDate = Date() }
    }
}


private struct EmojiGridPicker: View {
    @Binding var selection: String
    @Environment(\.dismiss) private var dismiss
    private let columns = [GridItem(.adaptive(minimum: 56), spacing: 8)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(faceEmojis, id: \.self) { emoji in
                        Button {
                            selection = emoji
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
                                Text(emoji).font(.system(size: 32))
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
}

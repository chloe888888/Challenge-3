import SwiftUI

struct EmojiPicker: View {

    @Binding var selectedEmoji: String
    @Binding var isPresented: Bool

    private let emojis: [String] = [
        // HAPPY
        "😀","😃","😄","😁","😆","😅","😂","🤣",
        "🙂","🙃","😉","😊","😇","🤠","😎","🤡",

        // SAD
        "😞","😔","😟","🙁","☹️","😣","😖","😫","😩",
        "🥺","🥹","😢","😭","😥","😓","😕","😶‍🌫️",

        // ANGRY
        "😤","😠","😡","🤬","😒","🙄","🤨","😬",

        // LOVE
        "🥰","😍","🤩","😘","😗","☺️","😙","😚","🤗",

        // CALM
        "😶","😴","😪","😌","😑","😐","🫥","🫤",

        // FEAR
        "😱","😨","😰","😳","😵","😵‍💫","🫢","🫣",

        // DISGUSTED
        "🤢","🤮","🤧","🤥"
    ]

    private let columns = [
        GridItem(.adaptive(minimum: 55), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: 40))
                            .padding(9)
                            .frame(alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(emoji == selectedEmoji
                                          ? Color.black
                                        .opacity(0.3)
                                          : Color.white)
                            )
                            .onTapGesture {
                                selectedEmoji = emoji
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Pick an Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        isPresented = false
                    }
                    .font(.system(size: 18, weight: .semibold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        isPresented = false
                    }
                    .font(.system(size: 18, weight: .semibold))
                }
            }
        }
    }
}

#Preview {
    EmojiPicker(selectedEmoji: .constant("😀"), isPresented: .constant(true))
}

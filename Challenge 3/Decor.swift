//
//  Decor.swift
//  Challenge 3
//
//  Created by Chloe Lin on 15/11/25.
//

import SwiftUI

struct Decoration: Identifiable {
    let id: Int
    let imageName: String
    let price: Int
}

private let allDecorations: [Decoration] = [
    .init(id: 1,  imageName: "Decor_1.3", price: 30),
    .init(id: 2,  imageName: "Decor_2",   price: 30),
    .init(id: 3,  imageName: "Decor_3",   price: 30),
    .init(id: 4,  imageName: "Decor_4",   price: 50),
    .init(id: 5,  imageName: "Decor_5",   price: 50),
    .init(id: 6,  imageName: "Decor_6",   price: 50),
    .init(id: 7,  imageName: "Decor_7",   price: 50),
    .init(id: 8,  imageName: "Decor_8",   price: 80),
    .init(id: 9,  imageName: "Decor 9",   price: 80),
    .init(id: 10, imageName: "Decor 10",  price: 80),
    .init(id: 11, imageName: "Decor 11",  price: 100),
    .init(id: 12, imageName: "Decor 12",  price: 100),
    .init(id: 13, imageName: "Decor 13",  price: 100),
    .init(id: 14, imageName: "Decor 14",  price: 120),
    .init(id: 15, imageName: "Decor 15",  price: 200),
    .init(id: 16, imageName: "Decor 16",  price: 200),
    .init(id: 17, imageName: "Decor 17",  price: 200),
    .init(id: 18, imageName: "Decor 18",  price: 250),
    .init(id: 19, imageName: "Decor 19",  price: 300),
    .init(id: 20, imageName: "Decor 20",  price: 500),
    .init(id: 21, imageName: "Decor 21",  price: 1000)
]

enum DecorButtonState {
    case buy
    case equip
    case equipped
}

struct Decor: View {
    @AppStorage("mojiBucks") private var mojiBucks: Int = 100
    @AppStorage("selectedDecoration") private var selectedDecoration: Int = 1
    @AppStorage("ownedDecorations") private var ownedDecorationsRaw: String = "1"

    private let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing, spacing: 2) {
                Text("Jarmoji Store")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                Text("Balance: $\(mojiBucks)")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
            }
            ZStack {
                Color(red: 0.95, green: 0.99, blue: 0.97)
                    .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(allDecorations) { decoration in
                            let state = buttonState(for: decoration)

                            DecorItemCard(
                                decoration: decoration,
                                state: state,
                                onTap: { handleTap(on: decoration, state: state) }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Decorations")
        }
    }


    private func isOwned(_ id: Int) -> Bool {
        let ids = ownedDecorationsRaw.split(separator: ",").compactMap { Int($0) }
        return ids.contains(id)
    }

    private func markOwned(_ id: Int) {
        var set = Set(ownedDecorationsRaw.split(separator: ",").compactMap { Int($0) })
        set.insert(id)
        ownedDecorationsRaw = set.sorted().map(String.init).joined(separator: ",")
    }

    private func buttonState(for decoration: Decoration) -> DecorButtonState {
        if decoration.id == selectedDecoration {
            return .equipped
        } else if isOwned(decoration.id) {
            return .equip
        } else {
            return .buy
        }
    }

    private func handleTap(on decoration: Decoration, state: DecorButtonState) {
        switch state {
        case .buy:
            guard mojiBucks >= decoration.price else { return }
            mojiBucks -= decoration.price
            markOwned(decoration.id)

        case .equip:
            selectedDecoration = decoration.id

        case .equipped:
            break
        }
    }
}

struct DecorItemCard: View {
    let decoration: Decoration
    let state: DecorButtonState
    let onTap: () -> Void

    private var buttonTitle: String {
        switch state {
        case .buy:      return "Buy"
        case .equip:    return "Equip"
        case .equipped: return "Equipped"
        }
    }

    private var buttonColors: (bg: Color, border: Color, text: Color) {
        switch state {
        case .buy:
            return (Color.white, Color.green.opacity(0.8), Color.green)
        case .equip:
            return (Color.yellow.opacity(0.15), Color.yellow.opacity(0.5), Color.orange)
        case .equipped:
            return (Color.appAccentGreen, Color.appAccentGreen, Color.green)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .overlay(
                        Circle()
                            .stroke(Color.appAccentGreen.opacity(0.4), lineWidth: 4)
                    )
                    .frame(width: 120, height: 120)

                Image(decoration.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
            }

            Text("$\(decoration.price)")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)

            Button(action: onTap) {
                Text(buttonTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(buttonColors.bg)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(buttonColors.border, lineWidth: 2)
                    )
                    .foregroundColor(buttonColors.text)
            }
            .disabled(state == .equipped)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    Decor()
}

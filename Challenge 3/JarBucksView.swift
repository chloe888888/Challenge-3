//
//  JarBucksView.swift
//  Challenge 3
//
//  Created by Sam Tan on 17/11/25.
//

import SwiftUI

struct JarBucksView: View {
    @State var message = ""
    var body: some View {
        VStack {
            Text(message)
            Button("Log in") {
                let reward = jarbucksLoginReward()
                message = "you earned \(reward) jarbucks!"
            }
            .buttonStyle(.bordered)
            .font(.largeTitle)
            .fontWeight(.bold)
            .background(.appAccentGreen)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    JarBucksView()
}

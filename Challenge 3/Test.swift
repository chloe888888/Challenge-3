//
//  Test.swift
//  Challenge 3
//
//  Created by Chloe Lin on 17/11/25.
//

import SwiftUI

struct Test: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 5) {
                Text("Left")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .frame(width: geometry.size.width * 1)
                    .background(.yellow)
            }
        }
    }
}
#Preview{
    Test()
}

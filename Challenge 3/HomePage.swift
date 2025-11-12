//
//  HomePage.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 10/11/25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        VStack{
            Text("How are you feeling today?")
                .font(.system(size: 30, weight: .medium))
                .offset(y: -350)
        }
    }
}


#Preview {
    HomePage()
}

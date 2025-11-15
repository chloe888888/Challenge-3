//
//  Decor.swift
//  Challenge 3
//
//  Created by Chloe Lin on 15/11/25.
//

import SwiftUI

struct Decor: View {
    var body: some View {
        NavigationStack{
            ScrollView {
                Button {
                    print("Button Tapped!")
                } label: {
                    GeometryReader { geometry in
                        Image("Decor_1")
                            .resizable()
                            .background(.appAccentGreen)
                            .clipShape(Circle())
                            .clipped()
                            .scaledToFit()
                            .padding()
                            .frame(width: 200, height: 200)
                    }
                }
                
            }
            .navigationBarTitle("Decoration!")
        }
        
    }
       
}
    

#Preview {
    Decor()
}

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
                HStack{
                    Button {
                        print("Button Tapped!")
                    } label: {
                        
                        VStack {
                            ZStack{
                                Color.appAccentGreen
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay{
                                        Image("Decor_1")
                                            .resizable()
                                            .scaledToFill()
                                    }
                            }
                            .clipShape(Circle())
                            .padding(.horizontal)
                            Text("$20")
                        }
                        Button {
                            print("Button Tapped!")
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor_2")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$20")
                            }
                        }
                    }
                    .navigationBarTitle("Decoration!")
                }
            }
        }
    }
}



#Preview {
    Decor()
}

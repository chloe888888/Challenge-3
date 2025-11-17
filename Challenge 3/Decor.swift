//
//  Decor.swift
//  Challenge 3
//
//  Created by Chloe Lin on 15/11/25.
//

import SwiftUI

struct Decor: View {
    @State var decoration1Clicked = false
    @State var decoration2Clicked = false
    @State var decoration3Clicked = true
    var body: some View {
        NavigationStack{
            NavigationLink {
                Inventory()
            } label: {
                Text ("Inventory ->")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            ScrollView {
                VStack {
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration1Clicked = true
                            
                            decoration2Clicked = false
                            decoration3Clicked = false
                            //decoration4Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                                Image("Decor_1.3")
                                                    .resizable()
                                                    .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$10")
                            }
                        }
                        Button {
                            print("Button ")
                            decoration2Clicked = true
                            
                            decoration1Clicked = false
                            decoration3Clicked = false
                           // decoration4Clicked = false
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
                                Text("$10")
                            }
                        }
                    }
                    HStack{
                        Button {
                            print("Button ")
                            decoration3Clicked = true
                            
                            decoration1Clicked = false
                            decoration2Clicked = false
                          //  decoration4Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor_3")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$20")
                            }
                        }
                        Button {
                            print("Button ")
                            decoration2Clicked = true
                            decoration1Clicked = false
                            decoration3Clicked = false
                            
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor_4")
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

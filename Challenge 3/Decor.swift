//
//  Decor.swift
//  Challenge 3
//
//  Created by Chloe Lin on 15/11/25.
//

import SwiftUI

struct Decor: View {
    @State var decoration1Clicked = true
    @State var decoration2Clicked = false
    @State var decoration3Clicked = false
    @State var decoration4Clicked = false
    @State var decoration5Clicked = false
    @State var decoration6Clicked = false
    @State var decoration7Clicked = false
    @State var decoration8Clicked = false
    @State var decoration9Clicked = false
    @State var decoration10Clicked = false
    @State var decoration11Clicked = false
    @State var decoration12Clicked = false
    @State var decoration13Clicked = false
    @State var decoration14Clicked = false
    @State var decoration15Clicked = false
    @State var decoration16Clicked = false
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
                            decoration4Clicked = true
                            
                            decoration1Clicked = false
                            
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
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration5Clicked = true
                            
                            decoration1Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor_5")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$20")
                            }
                        }
                            Button {
                                print("Button Tapped!")
                                decoration6Clicked = true
                                
                                decoration1Clicked = false
                            } label: {
                                
                                VStack {
                                    ZStack{
                                        Color.appAccentGreen
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay{
                                                Image("Decor_6")
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                    }
                                    .clipShape(Circle())
                                    .padding(.horizontal)
                                    Text("$20")
                                }
                            }
                    }
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration8Clicked = true
                            
                            decoration1Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor_8")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$50")
                            }
                        }
                            Button {
                                print("Button Tapped!")
                                decoration7Clicked = true
                                
                                decoration1Clicked = false
                            } label: {
                                
                                VStack {
                                    ZStack{
                                        Color.appAccentGreen
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay{
                                                Image("Decor_7")
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                    }
                                    .clipShape(Circle())
                                    .padding(.horizontal)
                                    Text("$50")
                                }
                            }
                    }
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration9Clicked = true
                            
                            decoration1Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor 9")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$60")
                            }
                        }
                            Button {
                                print("Button Tapped!")
                                decoration10Clicked = true
                                
                                decoration1Clicked = false
                            } label: {
                                
                                VStack {
                                    ZStack{
                                        Color.appAccentGreen
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay{
                                                Image("Decor 10")
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                    }
                                    .clipShape(Circle())
                                    .padding(.horizontal)
                                    Text("100")
                                }
                            }
                    }
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration11Clicked = true
                            
                            decoration1Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor 11")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$150")
                            }
                        }
                            Button {
                                print("Button Tapped!")
                                decoration12Clicked = true
                                
                                decoration1Clicked = false
                            } label: {
                                
                                VStack {
                                    ZStack{
                                        Color.appAccentGreen
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay{
                                                Image("Decor 12")
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                    }
                                    .clipShape(Circle())
                                    .padding(.horizontal)
                                    Text("150")
                                }
                            }
                    }
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration13Clicked = true
                            
                            decoration1Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor 13")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$200")
                            }
                        }
                            Button {
                                print("Button Tapped!")
                                decoration14Clicked = true
                                
                                decoration1Clicked = false
                            } label: {
                                
                                VStack {
                                    ZStack{
                                        Color.appAccentGreen
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay{
                                                Image("Decor 14")
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                    }
                                    .clipShape(Circle())
                                    .padding(.horizontal)
                                    Text("200")
                                }
                            }
                    }
                    HStack{
                        Button {
                            print("Button Tapped!")
                            decoration15Clicked = true
                            
                            decoration1Clicked = false
                        } label: {
                            
                            VStack {
                                ZStack{
                                    Color.appAccentGreen
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay{
                                            Image("Decor 15")
                                                .resizable()
                                                .scaledToFill()
                                        }
                                }
                                .clipShape(Circle())
                                .padding(.horizontal)
                                Text("$200")
                            }
                        }
                            Button {
                                print("Button Tapped!")
                                decoration16Clicked = true
                                
                                decoration1Clicked = false
                            } label: {

                                VStack {
                                    ZStack{
                                        Color.appAccentGreen
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay{
                                                Image("Decor 16")
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                    }
                                    .clipShape(Circle())
                                    .padding(.horizontal)
                                    Text("200")
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

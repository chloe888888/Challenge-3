//
//  info.swift
//  Challenge 3
//
//  Created by Chloe Lin on 22/11/25.
//

import SwiftUI

struct info: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Color(red: 0.96, green: 0.99, blue: 0.97)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Angry")
                            .font(.system(size: 22))
                            .frame(width: 90, alignment: .leading)
                        
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 2)
                            .padding(10)
                        Image("angry1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .padding(30)
                    }
                    HStack {
                        Text("Calm")
                            .font(.system(size: 22))
                            .frame(width: 90, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 2)
                            .padding(10)
                        Image("calm1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .padding(30)
                    }
                    HStack {
                        Text("Disgust")
                            .font(.system(size: 22))
                            .frame(width: 90, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 2)
                            .padding(10)
                        Image("disgust1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .padding(30)
                    }
                    HStack {
                        Text("Happy")
                            .font(.system(size: 22))
                            .frame(width: 90, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 2)
                            .padding(10)
                        Image("happy1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .padding(30)
                    }
                    HStack {
                        Text("Love")
                            .font(.system(size: 22))
                            .frame(width: 90, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 2)
                            .padding(10)
                        Image("love1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .padding(30)
                    }
                    HStack {
                        Text("Sad")
                            .font(.system(size: 22))
                            .frame(width: 90, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 20, height: 2)
                            .padding(10)
                        Image("sad1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .padding(30)
                    }
                    
                }
                .padding(55)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                .padding(.horizontal, 28)
                .padding(.top, 10)
            }
            .navigationBarTitle("Jar Colours")
        }
    }
    }
    
    #Preview {
        info()
    
}

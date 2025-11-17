//
//  Inventory.swift
//  Challenge 3
//
//  Created by Chloe Lin on 16/11/25.
//

import SwiftUI

struct Inventory: View {
    private var decorShop = Decor()
    var body: some View {
        NavigationStack{
            Group {
                if decorShop.decoration1Clicked {
                    Image("Decor_1")
                } else if decorShop.decoration2Clicked {
                    Image("Decor_2")
                        .resizable()
                } else if decorShop.decoration3Clicked {
                    Image("Decor_3")
                        .resizable()
                } else if decorShop.decoration4Clicked {
                    Image("Decor_4.2")
                        .resizable()
                    Image("Decor_4.3")
                } else if decorShop.decoration5Clicked {
                    Image("Decor_5.2")
                        .resizable()
                    Image("Decor_5.3")
                } else if decorShop.decoration6Clicked {
                    Image("Decor_6.2")
                        .resizable()
                    Image("Decor_6.3")
                } else if decorShop.decoration7Clicked {
                    Image("Decor_7.2")
                        .resizable()
                    Image("Decor_7.3")
                } else if decorShop.decoration8Clicked {
                    Image("Decor_8.2")
                        .resizable()
                    Image("Decor_8.3")
                }
            }
                .navigationBarTitle("Inventory")
        }
    }
}
#Preview {
    Inventory()
}

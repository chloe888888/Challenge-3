//
//  MoodData.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 14/11/25.
//

import SwiftUI

final class MoodData: ObservableObject {
    
    @Published var selectedEmojis: [Int: String] = [:]
}

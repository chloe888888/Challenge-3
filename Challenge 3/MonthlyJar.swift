//
//  MonthlyJar.swift
//  Challenge 3
//
//  Created by La Wun Eain  on 17/11/25.
//

import Foundation
import SwiftData

@Model
final class MonthlyJar {
    var month: Date

    var dominantCategory: String

    var label: String

    init(month: Date, dominantCategory: String, label: String) {
        self.month = month
        self.dominantCategory = dominantCategory
        self.label = label
    }
}

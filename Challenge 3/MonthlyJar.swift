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
    var label: String
    var dominantCategory: String
<<<<<<< HEAD

=======
>>>>>>> main
    init(month: Date, label: String, dominantCategory: String) {
        self.month = month
        self.label = label
        self.dominantCategory = dominantCategory
    }
}


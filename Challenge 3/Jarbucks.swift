//
//  Jarbucks.swift
//  Challenge 3
//
//  Created by Sam Tan on 17/11/25.
//

import Foundation

func jarbucksLoginReward() -> Int {
    
    let defaults = UserDefaults.standard
    let today = Date()
    let calendar = Calendar.current
    let lastLogin = defaults.object(forKey: "lastLogin") as? Date
    var streak = defaults.integer(forKey: "jarbuckStreak")
    var jarBucks = defaults.integer(forKey: "jarbucks")
    if let last = lastLogin {
        if calendar.isDate(last, inSameDayAs: today) {
            return 0
        }
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        if calendar.isDate(last, inSameDayAs: yesterday) {
            streak += 1
        } else {
            streak = 1
        }
    } else {
        streak = 1
    }
    let reward = streak
    jarBucks += reward
    
    defaults.set(today, forKey: "lastLogin")
    defaults.set(streak, forKey: "streak")
    defaults.set(jarBucks, forKey: "jarBucks")
    return reward
}

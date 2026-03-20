//
//  ProgressModel.swift
//  CCG
//
//  Created by H2026215 on 2026/3/20.
//


import Foundation
import FirebaseFirestore

struct UserProgress: Codable {
    var userId: String
    var dishCompletions: [String: Int]
    var lastUpdated: Date
    
    init(userId: String) {
        self.userId = userId
        self.dishCompletions = [:]
        self.lastUpdated = Date()
    }
    
    func badgeLevel(for dishName: String) -> BadgeLevel {
        let count = dishCompletions[dishName] ?? 0
        switch count {
        case 0: return .none
        case 1...2: return .bronze
        case 3...4: return .silver
        case 5...: return .gold
        default: return .none
        }
    }
    
    var earnedBadges: [(dishName: String, level: BadgeLevel, count: Int)] {
        var badges: [(String, BadgeLevel, Int)] = []
        for (dishName, count) in dishCompletions where count > 0 {
            badges.append((dishName, badgeLevel(for: dishName), count))
        }
        return badges
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "dishCompletions": dishCompletions,
            "lastUpdated": Timestamp(date: lastUpdated)
        ]
    }
}

//
//  BadgeModel.swift
//  UserLoginPage
//
//  Created by H2026215 on 2026/2/27.
//

import Foundation

enum BadgeLevel: String, Codable {
    case none = "none"
    case bronze = "bronze"
    case silver = "silver"
    case gold = "gold"
    
    var borderColor: String {
        switch self {
        case .none: return "badge_border_none"
        case .bronze: return "badge_border_bronze"
        case .silver: return "badge_border_silver"
        case .gold: return "badge_border_gold"
        }
    }
    
    var displayName: String {
        switch self {
        case .none: return "???"
        case .bronze: return "Bronze"
        case .silver: return "Silver"
        case .gold: return "Gold"
        }
    }
}

struct DishBadge: Codable, Identifiable {
    let dishName: String
    let dishIconName: String
    var completionCount: Int
    var level: BadgeLevel
    
    var id: String { dishName }
    
    mutating func addCompletion() {
        completionCount += 1
        updateLevel()
    }
    
    private mutating func updateLevel() {
        switch completionCount {
        case 0:
            level = .none
        case 1...2:
            level = .bronze
        case 3...4:
            level = .silver
        case 5...:
            level = .gold
        default:
            level = .none
        }
    }
}

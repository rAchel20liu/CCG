//
//  BadgeViewModel.swift
//  CCG
//
//  Created by H2026215 on 2026/2/27.
//


//
//  BadgeViewModel.swift
//  UserLoginPage
//
//  Created by H2026215 on 2026/2/27.
//

import Foundation
import Combine  // 需要导入 Combine

class BadgeViewModel: ObservableObject {  // 确保这一行正确
    @Published var dishBadges: [DishBadge] = []
    
    private let savedDataKey = "savedBadges"
    
    init() {
        loadBadges()
    }
    
    func loadBadges() {
        guard let data = UserDefaults.standard.data(forKey: savedDataKey) else {
            createDefaultBadges()
            return
        }
        
        do {
            dishBadges = try JSONDecoder().decode([DishBadge].self, from: data)
        } catch {
            print("Failed to load badges: \(error)")
            createDefaultBadges()
        }
    }
    
    private func createDefaultBadges() {
        let allDishes = getAllDishNamesWithIcons()
        dishBadges = allDishes.map { dishName, iconName in
            DishBadge(dishName: dishName, dishIconName: iconName, completionCount: 0, level: .none)
        }
        saveBadges()
    }
    
    private func getAllDishNamesWithIcons() -> [(String, String)] {
        var result: [(String, String)] = []
        
        // 北京菜
        result.append(("Beijing Zhajiang Mian", "dish_zhajiangmian"))
        result.append(("Peking Duck", "dish_pekingduck"))
        result.append(("Shredded Pork with Scallions", "dish_pork"))
        result.append(("Fried Liver with Garlic", "dish_liver"))
        result.append(("Ai Wo Wo", "dish_aiwowo"))
        result.append(("Candied Sweet Potatoes", "dish_sweetpotato"))
        result.append(("Lv Da Gun", "dish_lvdagun"))
        result.append(("Braised Beef Brisket with Turnip", "dish_beef"))
        result.append(("Shuizhu Rou", "dish_shuizhu"))
        result.append(("Emperor Qianlong's Cabbage", "dish_cabbage"))
        
        // 四川菜
        result.append(("Mapo Tofu", "dish_mapotofu"))
        result.append(("Kung Pao Chicken", "dish_kungpao"))
        
        // 江苏菜
        result.append(("Sixi Meatball", "dish_sixi"))
        result.append(("Huangqiao Shaobing", "dish_shaobing"))
        
        // 闽南菜
        result.append(("Shachamian", "dish_shachamian"))
        result.append(("hailijian", "dish_hailijian"))
        
        // 广东菜
        result.append(("Wenchang Chicken", "dish_wenchang"))
        result.append(("Baozaifan", "dish_baozaifan"))
        
        // 安徽菜
        result.append(("choujueyu", "dish_choujueyu"))
        result.append(("huainanniuroutang", "dish_niuroutang"))
        
        return result
    }
    
    private func saveBadges() {
        do {
            let data = try JSONEncoder().encode(dishBadges)
            UserDefaults.standard.set(data, forKey: savedDataKey)
        } catch {
            print("Failed to save badges: \(error)")
        }
    }
    
    func incrementCompletion(for dishName: String) {
        if let index = dishBadges.firstIndex(where: { $0.dishName == dishName }) {
            dishBadges[index].addCompletion()
            saveBadges()  // 保存更改
        }
    }
    
    func badgeLevel(for dishName: String) -> BadgeLevel {
        return dishBadges.first(where: { $0.dishName == dishName })?.level ?? .none
    }
    
    var earnedBadges: [DishBadge] {
        return dishBadges.filter { $0.level != .none }
    }
}

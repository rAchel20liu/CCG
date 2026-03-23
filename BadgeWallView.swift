//
//  BadgeWallView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/13.
//
//
//  BadgeWallView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2026/2/27.
//
//
//  BadgeWallView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/13.
//

import SwiftUI

struct BadgeWallView: View {
    @EnvironmentObject var progressVM: ProgressViewModel  // 从外部传入，不自己创建
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if progressVM.earnedBadges.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    Image(systemName: "medal")
                        .font(.system(size: 80))
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51).opacity(0.3))
                    
                    Text("No Badges Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Text("Complete dishes to earn badges!\nBronze: 1 time | Silver: 3 times | Gold: 5 times")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        // 遍历 earnedBadges，注意它是元组数组，不是对象数组
                        ForEach(progressVM.earnedBadges, id: \.dishName) { badge in
                            BadgeCard(
                                dishName: badge.dishName,
                                level: badge.level,
                                count: badge.count
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.white)
        .navigationTitle("Badge Wall")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// BadgeCard 需要修改，因为现在接收的是参数而不是 DishBadge 对象
struct BadgeCard: View {
    let dishName: String
    let level: BadgeLevel
    let count: Int
    
    // 根据菜品名称返回对应的图标名称
    var iconName: String {
        switch dishName {
        case "Beijing Zhajiang Mian":
            return "dish_zhajiangmian"
        case "Peking Duck":
            return "dish_pekingduck"
        case "Shredded Pork with Scallions":
            return "dish_pork"
        case "Fried Liver with Garlic":
            return "dish_liver"
        case "Ai Wo Wo":
            return "dish_aiwowo"
        case "Candied Sweet Potatoes":
            return "dish_sweetpotato"
        case "Lv Da Gun":
            return "dish_lvdagun"
        case "Braised Beef Brisket with Turnip":
            return "dish_beef"
        case "Shuizhu Rou":
            return "dish_shuizhu"
        case "Emperor Qianlong's Cabbage":
            return "dish_cabbage"
        case "Mapo Tofu":
            return "dish_mapotofu"
        case "Kung Pao Chicken":
            return "dish_kungpao"
        case "Sixi Meatball":
            return "dish_sixi"
        case "Huangqiao Shaobing":
            return "dish_shaobing"
        case "Shachamian":
            return "dish_shachamian"
        case "hailijian":
            return "dish_hailijian"
        case "Wenchang Chicken":
            return "dish_wenchang"
        case "Baozaifan":
            return "dish_baozaifan"
        case "choujueyu":
            return "dish_choujueyu"
        case "huainanniuroutang":
            return "dish_niuroutang"
        default:
            return "fork.knife"  // 默认图标
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // 徽章外框
                Circle()
                    .stroke(levelColor, lineWidth: 3)
                    .frame(width: 80, height: 80)
                    .background(
                        Circle()
                            .fill(backgroundColor)
                    )
                
                // 菜品图标
                if UIImage(named: iconName) != nil {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } else {
                    // 如果图片不存在，用系统图标代替
                    Image(systemName: "fork.knife")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            
            Text(dishName)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 40)
            
            Text(level.displayName)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(levelColor)
            
            Text("\(count) time\(count > 1 ? "s" : "")")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(8)
        .frame(height: 180)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(levelColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    // 等级对应的颜色
    var levelColor: Color {
        switch level {
        case .bronze:
            return Color(red: 0.80, green: 0.50, blue: 0.20)
        case .silver:
            return Color.gray
        case .gold:
            return Color(red: 1.00, green: 0.84, blue: 0.00)
        case .none:
            return Color.gray
        }
    }
    
    // 背景色（半透明版本）
    var backgroundColor: Color {
        switch level {
        case .bronze:
            return Color(red: 0.80, green: 0.50, blue: 0.20).opacity(0.2)
        case .silver:
            return Color.gray.opacity(0.2)
        case .gold:
            return Color(red: 1.00, green: 0.84, blue: 0.00).opacity(0.2)
        case .none:
            return Color.gray.opacity(0.1)
        }
    }
}

#Preview {
    NavigationStack {
        // 预览时需要提供 progressVM
        BadgeWallView()
            .environmentObject(ProgressViewModel())
    }
}

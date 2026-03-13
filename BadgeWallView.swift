//
//  BadgeWallView.swift
//  CCG
//
//  Created by H2026215 on 2026/2/27.
//
//
//  BadgeWallView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2026/2/27.
//

import SwiftUI

struct BadgeWallView: View {
    @StateObject private var badgeVM = BadgeViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("Badge Wall")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                .padding(.top, 20)
            
            if badgeVM.earnedBadges.isEmpty {
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
                        ForEach(badgeVM.earnedBadges) { badge in
                            BadgeCard(badge: badge)
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

struct BadgeCard: View {
    let badge: DishBadge
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image(badge.level.borderColor)
                    .resizable()
                    .frame(width: 90, height: 90)
                
                Image(badge.dishIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            Text(badge.dishName)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 40)
            
            Text(badge.level.displayName)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(levelColor)
            
            Text("\(badge.completionCount) time\(badge.completionCount > 1 ? "s" : "")")
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
    
    var levelColor: Color {
        switch badge.level {
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
}

#Preview {
    NavigationStack {
        BadgeWallView()
    }
}

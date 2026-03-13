//
//  ShowcaseView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/15.
//
//
//  ShowcaseView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/15.
//
//
//  ShowcaseView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/15.
//
import SwiftUI

struct ShowcaseView: View {
<<<<<<< HEAD
    // 移除 @State private var selectedTab = 1
    
    var body: some View {
        // 移除 VStack 包装，直接返回内容
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                Text("Showcase")
                    .font(.largeTitle)
                    .bold()
                
                Text("This is the showcase page.")
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 50)
            }
            .padding(.bottom, 70) // 给底部 Tab 留空间
        }
        .background(Color.white)
        // 移除底部的 BottomTabBar
=======
    @State private var selectedTab = 1
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer().frame(height: 50)
                
                // Badge 按钮
                NavigationLink {
                    BadgeWallView()
                } label: {
                    showcaseButton(title: "Badge", imageName: "ShowcaseViewBadge")
                }
                
                // My Dish 按钮
                NavigationLink {
                    PhotoWallView()
                } label: {
                    showcaseButton(title: "My Dish", imageName: "ShowcaseViewDish")
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
    
    private func showcaseButton(title: String, imageName: String) -> some View {
        HStack {
            Text(title)
                .font(.custom("Roboto", size: 45).weight(.bold))
                .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                .padding(.leading, 30)
            
            Spacer()
            
            // 修改这里：给图片设置固定大小
            Image(imageName)
                .resizable()  // 允许调整大小
                .scaledToFit() // 保持宽高比
                .frame(width: 150, height: 200) // 设置固定大小
                .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                .padding(.trailing, 20)
        }
        .frame(width: 348, height: 190)
        .background(Color(red: 0.34, green: 0.24, blue: 0.51).opacity(0.25))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.34, green: 0.24, blue: 0.51), lineWidth: 1.5)
        )
>>>>>>> badgewall
    }
}

#Preview {
    ShowcaseView()
}

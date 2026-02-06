//
//  Home.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/11/14.
// testing git
//
import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // 🔹 顶部搜索栏
                topSearchBar
                    .padding(.bottom, 12)
                    .background(Color.white)
                    .zIndex(1)
                
                // 🔹 Scrollable 内容
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        regionCard(title: "Beijing", imageName: "beijing", dishes: ChapterData.beijing)
                        regionCard(title: "Sichuan", imageName: "sichuan", dishes: ChapterData.sichuan)
                        regionCard(title: "Jiangsu", imageName: "jiangsu", dishes: ChapterData.jiangsu)
                        regionCard(title: "Minnan", imageName: "minnan", dishes: ChapterData.minnan)
                        regionCard(title: "Guangdong", imageName: "guangdong", dishes: ChapterData.guangdong)
                        regionCard(title: "Anhui", imageName: "anhui", dishes: ChapterData.anhui)
                        
                        // 给底部 Tab 留空间
                        Spacer().frame(height: 70)
                    }
                    .padding(.top)
                    .padding(.bottom, 9)
                    .background(Color.white) // 保证背景为白色
                }
                
                // 🔹 底部固定 Tab
                HStack {
                    Spacer()
                    tabButton(icon: "house.fill", title: "Home")
                    Spacer()
                    tabButton(icon: "sparkles", title: "Showcase")
                    Spacer()
                    tabButton(icon: "person.fill", title: "Profile")
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.white)  // 实心白底
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: -2)
            }
            .background(Color.white) // 背景白色，移除灰色效果
            .navigationBarHidden(true)
        }
    }
    
    private func tabButton(icon: String, title: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
            Text(title)
                .font(.system(size: 12))
        }
        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
    }
}

private var topSearchBar: some View {
    HStack {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: .constant(""))
                .font(.system(size: 16))
        }
        .padding(11)
        .background(Color.white)
        .cornerRadius(100)

        Spacer()

        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 45, height: 45)
    }
    .padding(.horizontal, 24)
}

private func regionCard(title: String, imageName: String, dishes: [Dish]) -> some View {
    NavigationLink {
        ChapterView(cityName: title, dishes: dishes)
    } label: {
        HStack {
            Text(title)
                .font(.system(size: 26))
                .fontWeight(.semibold)
                .padding(.leading, 20)
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(8)
                .clipped()
        }
        .padding(.horizontal, 10)
        .frame(width: 348, height: 153)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.34, green: 0.24, blue: 0.51), lineWidth: 3)
        )
    }
    .buttonStyle(.plain)
}


#Preview {
    HomeView()
}

//
//  BottomTabBar.swift
//  CCG
//
//  Created by H2026215 on 2026/2/27.
//

import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            tabButton(index: 0, icon: "house.fill", title: "Home")
            
            Spacer()
            
            tabButton(index: 1, icon: "sparkles", title: "Showcase")
            
            Spacer()
            
            tabButton(index: 2, icon: "person.fill", title: "Profile")
            
            Spacer()
        }
        .frame(height: 60)
        .background(Color.white)
        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: -2)
    }
    
    private func tabButton(index: Int, icon: String, title: String) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                Text(title)
                    .font(.system(size: 12))
            }
            .foregroundColor(selectedTab == index ?
                Color(red: 0.34, green: 0.24, blue: 0.51) :
                Color.gray.opacity(0.5))
        }
    }
}

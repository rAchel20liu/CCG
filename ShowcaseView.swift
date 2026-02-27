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
    }
}

#Preview {
    ShowcaseView()
}

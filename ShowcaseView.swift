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
    @State private var selectedTab = 1  // 新增：Showcase tab
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 内容区
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
            
            // 底部固定 Tab - 替换原来的静态tab
           
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}

#Preview {
    ShowcaseView()
}

//
//  Untitled.swift
//  CCG
//
//  Created by H2026215 on 2026/3/30.
//


//
//  ProfileView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/30.
//

//
//  ProfileView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/30.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var selectedTab = 2
    @State private var showSettings = false
    
    // 计算各种徽章数量
    private var bronzeCount: Int {
        progressVM.earnedBadges.filter { $0.level == .bronze }.count
    }
    
    private var silverCount: Int {
        progressVM.earnedBadges.filter { $0.level == .silver }.count
    }
    
    private var goldCount: Int {
        progressVM.earnedBadges.filter { $0.level == .gold }.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部内容区域
            VStack(alignment: .leading, spacing: 16) {
                // 第一行：头像 + 用户名/邮箱 + 齿轮
                HStack(alignment: .center, spacing: 16) {
                    // 大头像
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    
                    // 用户名和邮箱
                    VStack(alignment: .leading, spacing: 4) {
                        if let user = Auth.auth().currentUser {
                            // 用户名（可以从 Firebase 获取，暂时用邮箱前缀）
                            Text(user.email?.components(separatedBy: "@").first ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text(user.email ?? "No Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // 齿轮图标 - 顶右上格
                    NavigationLink {
                        SettingsView()
                            .environmentObject(authVM)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 第二行：横线
                Divider()
                    .padding(.horizontal, 20)
                
                // 第三行：Info 标题
                Text("Info")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    .padding(.horizontal, 20)
                
                // 第四行：注册时间
                HStack {
                    Text("Joined")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("March 2025") // 可以改成真实的注册时间
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // 第五行：徽章统计
                VStack(alignment: .leading, spacing: 12) {
                    Text("Badges")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    
                    HStack(spacing: 20) {
                        // 金牌
                        BadgeStatView(
                            icon: "medal.fill",
                            color: Color(red: 1.00, green: 0.84, blue: 0.00),
                            count: goldCount,
                            name: "Gold"
                        )
                        
                        // 银牌
                        BadgeStatView(
                            icon: "medal.fill",
                            color: Color.gray,
                            count: silverCount,
                            name: "Silver"
                        )
                        
                        // 铜牌
                        BadgeStatView(
                            icon: "medal.fill",
                            color: Color(red: 0.80, green: 0.50, blue: 0.20),
                            count: bronzeCount,
                            name: "Bronze"
                        )
                        
                        
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Spacer()
            }
            
            // 底部 Tab
    
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}

// 徽章统计卡片
struct BadgeStatView: View {
    let icon: String
    let color: Color
    let count: Int
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(name)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(ProgressViewModel())
}

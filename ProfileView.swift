//
//  ProfileView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/15.
//
//
//  ProfileView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/15.
//
//
//  ProfileView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/15.
//
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showLogoutAlert = false
    // 移除 @State private var selectedTab = 2
    
    var body: some View {
        // 移除 VStack 包装，直接返回内容
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                Button {
                    showLogoutAlert = true
                } label: {
                    Text("Log Out")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }
            }
            .padding(.bottom, 70) // 给底部 Tab 留空间
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .alert("Confirm Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                authVM.signOut()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        // 移除底部的 BottomTabBar
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}

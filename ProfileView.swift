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
    @State private var selectedTab = 2  // 新增：Profile tab
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 内容区
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
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}

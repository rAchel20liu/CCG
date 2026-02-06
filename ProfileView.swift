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
    
    var body: some View {
        NavigationStack {
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
                
                // 底部固定 Tab
                bottomTab
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
    
    private var bottomTab: some View {
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
        .background(Color.white)
        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: -2)
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

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}

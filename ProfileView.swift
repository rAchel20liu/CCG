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

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @StateObject private var profileVM = UserProfileViewModel()
    @State private var selectedTab = 2
    @State private var showEditName = false
    @State private var newUsername = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploadingAvatar = false
    
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
                    // 大头像（可点击上传）
                    Button {
                        showImagePicker = true
                    } label: {
                        ZStack {
                            if let avatarUrl = profileVM.userProfile?.avatarUrl {
                                CachedAsyncImage(url: URL(string: avatarUrl))
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                            }
                            
                            if isUploadingAvatar {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    // 用户名和邮箱
                    VStack(alignment: .leading, spacing: 4) {
                        // 可编辑的用户名
                        HStack(spacing: 8) {
                            Text(profileVM.userProfile?.username ?? "User")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Button {
                                newUsername = profileVM.userProfile?.username ?? ""
                                showEditName = true
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                            }
                        }
                        
                        if let user = Auth.auth().currentUser {
                            Text(user.email ?? "No Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // 齿轮图标
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
                    Text(profileVM.getJoinDateString())
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
                        BadgeStatView(
                            icon: "medal.fill",
                            color: Color(red: 1.00, green: 0.84, blue: 0.00),
                            count: goldCount,
                            name: "Gold"
                        )
                        
                        BadgeStatView(
                            icon: "medal.fill",
                            color: Color.gray,
                            count: silverCount,
                            name: "Silver"
                        )
                        
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
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .alert("Edit Username", isPresented: $showEditName) {
            TextField("Username", text: $newUsername)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                profileVM.updateUsername(newUsername)
            }
        } message: {
            Text("Enter your new username")
        }
        .alert("Error", isPresented: $profileVM.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(profileVM.errorMessage)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                isUploadingAvatar = true
                profileVM.uploadAvatar(image: image)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isUploadingAvatar = false
                    selectedImage = nil
                }
            }
        }
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

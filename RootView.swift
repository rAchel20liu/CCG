//
//  RootView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2026/1/4.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var badgeVM = BadgeViewModel()
    @StateObject private var progressVM = ProgressViewModel()
    @StateObject private var photoVM = PhotoViewModel()
    
    var body: some View {
        if authVM.isLoggedIn {
            HomeView()
                .environmentObject(authVM)
                .environmentObject(badgeVM)
                .environmentObject(progressVM)
                .environmentObject(photoVM)
            
        } else {
            ContentView()
                .environmentObject(authVM)
        }
    }
}

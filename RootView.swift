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

    var body: some View {
        if authVM.isLoggedIn {
            HomeView()
                .environmentObject(authVM)
        } else {
            ContentView()
                .environmentObject(authVM)
        }
    }
}

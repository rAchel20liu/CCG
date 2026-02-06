//
//  UserLoginPageApp.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/11/10.
//

import SwiftUI
import Firebase

@main
struct UserLoginPageApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }

    }
}


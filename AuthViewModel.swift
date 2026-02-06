//
//  AuthViewModel.swift
//  UserLoginPage
//
//  Created by H2026215 on 2026/1/4.
//
import Foundation
import FirebaseAuth
import Combine   

class AuthViewModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = (user != nil)
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out failed:", error.localizedDescription)
        }
    }
}

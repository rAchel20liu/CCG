//
//  UserProfileViewModel.swift
//  CCG
//
//  Created by H2026215 on 2026/4/17.
//


import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    private var listener: ListenerRegistration?
    
    var userId: String? { Auth.auth().currentUser?.uid }
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        guard let userId = userId else { return }
        
        isLoading = true
        
        listener = db.collection("userProfiles").document(userId)
            .addSnapshotListener { [weak self] document, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("Error loading profile: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    self.userProfile = try? document.data(as: UserProfile.self)
                } else {
                    // 创建默认资料
                    self.createDefaultProfile(userId: userId)
                }
            }
    }
    
    private func createDefaultProfile(userId: String) {
        let email = Auth.auth().currentUser?.email ?? ""
        let defaultUsername = email.components(separatedBy: "@").first ?? "User"
        
        let profile = UserProfile(userId: userId, username: defaultUsername)
        
        db.collection("userProfiles").document(userId).setData(profile.toDictionary()) { error in
            if let error = error {
                print("Error creating profile: \(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.userProfile = profile
        }
    }
    
    func updateUsername(_ newUsername: String) {
        guard let userId = userId,
              let profile = userProfile,
              !newUsername.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let trimmedUsername = newUsername.trimmingCharacters(in: .whitespaces)
        
        db.collection("userProfiles").document(userId).updateData([
            "username": trimmedUsername
        ]) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
        
        // 本地立即更新
        userProfile?.username = trimmedUsername
    }
    
    func uploadAvatar(image: UIImage) {
        guard let userId = userId,
              let imageData = image.jpegData(compressionQuality: 0.6) else { return }
        
        isLoading = true
        
        let storageRef = storage.reference().child("userAvatars/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else { return }
                
                self.db.collection("userProfiles").document(userId).updateData([
                    "avatarUrl": downloadURL.absoluteString
                ]) { error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            self.showError = true
                        } else {
                            self.userProfile?.avatarUrl = downloadURL.absoluteString
                        }
                    }
                }
            }
        }
    }
    
    func getJoinDateString() -> String {
        guard let joinDate = userProfile?.joinDate else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: joinDate)
    }
    
    deinit {
        listener?.remove()
    }
}

//
//  PhotoViewModel.swift
//  CCG
//
//  Created by H2026215 on 2026/4/10.
//
//
//  PhotoViewModel.swift
//  CCG
//
//  Created by H2026215 on 2026/4/10.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import Combine

class PhotoViewModel: ObservableObject {
    @Published var photos: [UserPhoto] = []
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    var userId: String? { Auth.auth().currentUser?.uid }
    
    init() {
        loadPhotos()
    }
    
    func loadPhotos() {
        guard let userId = userId else { return }
        
        isLoading = true
        
        db.collection("userPhotos").document(userId).collection("photos")
            .order(by: "uploadDate", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("Error loading photos: \(error)")
                    return
                }
                
                self.photos = snapshot?.documents.compactMap { document in
                    try? document.data(as: UserPhoto.self)
                } ?? []
            }
    }
    
    func uploadPhoto(image: UIImage, dishName: String) {
        guard let userId = userId else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let photoId = UUID().uuidString
        let storageRef = storage.reference().child("userPhotos/\(userId)/\(photoId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Upload error: \(error)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else { return }
                
                let photo = UserPhoto(
                    id: photoId,
                    userId: userId,
                    dishName: dishName,
                    imageUrl: downloadURL.absoluteString,
                    uploadDate: Date()
                )
                
                do {
                    try self.db.collection("userPhotos").document(userId)
                        .collection("photos").document(photoId)
                        .setData(from: photo)
                } catch {
                    print("Firestore error: \(error)")
                }
            }
        }
    }
}

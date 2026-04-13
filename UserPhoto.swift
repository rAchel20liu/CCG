//
//  UserPhoto.swift
//  CCG
//
//  Created by H2026215 on 2026/4/10.
//


import Foundation
import FirebaseFirestore

struct UserPhoto: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let dishName: String
    let imageUrl: String
    let uploadDate: Date
    
    init(id: String = UUID().uuidString, userId: String, dishName: String, imageUrl: String, uploadDate: Date = Date()) {
        self.id = id
        self.userId = userId
        self.dishName = dishName
        self.imageUrl = imageUrl
        self.uploadDate = uploadDate
    }
}

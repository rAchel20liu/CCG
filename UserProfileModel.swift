//
//  UserProfileModel.swift
//  CCG
//
//  Created by H2026215 on 2026/4/17.
//


import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
    @DocumentID var id: String?
    var userId: String
    var username: String
    var avatarUrl: String?
    var joinDate: Date
    
    init(userId: String, username: String, avatarUrl: String? = nil) {
        self.userId = userId
        self.username = username
        self.avatarUrl = avatarUrl
        self.joinDate = Date()
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "username": username,
            "avatarUrl": avatarUrl as Any,
            "joinDate": Timestamp(date: joinDate)
        ]
    }
}

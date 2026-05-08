//
//  FirebaseModels.swift
//  CCG
//
//  Created by H2026215 on 2026/4/27.
//

import Foundation
import FirebaseFirestore

// MARK: - Firestore 数据结构

// 地区
struct Region: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let coverImage: String
    let order: Int
    let dishId: [String]?  // 注意：dishId，没有 s
}

// 菜品
struct FirestoreDish: Codable, Identifiable {
    @DocumentID var id: String?
    let regionId: String
    let number: Int
    let name: String
    let description: String
    let ingredients: [FirestoreIngredient]
    let recipesteps: [FirestoreRecipeStep]
}

// 配料
struct FirestoreIngredient: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let unit: String
    let amountPerPerson: Double
}

// 步骤
struct FirestoreRecipeStep: Codable, Identifiable {
    @DocumentID var id: String?
    let stepNumber: Int
    let title: String
    let description: String
    let timerDuration: Int?  // nil 表示无倒计时
}

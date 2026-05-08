//
//  LocalModels.swift
//  CCG
//
//  Created by H2026215 on 2026/4/27.
//

import Foundation

// UI 显示的菜品信息
struct DishInfo: Identifiable {
    let id = UUID()
    let dishname: String
    let description: String
    let ingredients: [Ingredient]
    let recipesteps: [RecipeStep]
}

// UI 显示的配料
struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let unit: String
    let amountPerPerson: Double
}

// UI 显示的步骤
struct RecipeStep: Identifiable {
    let id = UUID()
    let stepNumber: Int
    let title: String
    let description: String
    let timerDuration: Int?  // nil 表示无倒计时
}

// 转换函数：FirestoreDish -> DishInfo
extension DishInfo {
    static func from(_ dish: FirestoreDish) -> DishInfo {
        return DishInfo(
            dishname: dish.name,
            description: dish.description,
            ingredients: dish.ingredients.map {
                Ingredient(name: $0.name, unit: $0.unit, amountPerPerson: $0.amountPerPerson)
            },
            recipesteps: dish.recipesteps.map {
                RecipeStep(
                    stepNumber: $0.stepNumber,
                    title: $0.title,
                    description: $0.description,
                    timerDuration: $0.timerDuration
                )
            }
        )
    }
}

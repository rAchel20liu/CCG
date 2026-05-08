//
//  DataService.swift
//  CCG
//
//  Created by H2026215 on 2026/4/27.
//

import Foundation
import FirebaseFirestore
import Combine

class DataService: ObservableObject {
    static let shared = DataService()
    private let db = Firestore.firestore()
    
    @Published var regions: [Region] = []
    @Published var dishes: [FirestoreDish] = []
    @Published var isLoading = false
    
    private init() {
        fetchRegions()
        fetchDishes()
    }
    
    func fetchRegions() {
        isLoading = true
        db.collection("regions")
            .order(by: "order")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                if let error = error {
                    print("Error fetching regions: \(error)")
                    return
                }
                self.regions = snapshot?.documents.compactMap { try? $0.data(as: Region.self) } ?? []
            }
    }
    
    func fetchDishes() {
        db.collection("dishes")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    return
                }
                self.dishes = snapshot?.documents.compactMap { document in
                    return try? document.data(as: FirestoreDish.self)
                } ?? []
            }
    }
    
    // 根据地区获取菜品 - 用 dishId 数组过滤
    func getDishes(for region: Region) -> [FirestoreDish] {
        guard let dishIds = region.dishId else {
            return []
        }
        let filtered = dishes.filter { dishIds.contains($0.id ?? "") }
        for dish in filtered {
        }
        return filtered.sorted { $0.number < $1.number }
    }
    
    func getDish(byId id: String) -> FirestoreDish? {
        dishes.first { $0.id == id }
    }
}

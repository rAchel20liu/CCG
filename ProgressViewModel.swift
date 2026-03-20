//
//  ProgressViewModel.swift
//  CCG
//
//  Created by H2026215 on 2026/3/20.
//


import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class ProgressViewModel: ObservableObject {
    @Published var userProgress: UserProgress?
    @Published var isLoading = false
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let localCacheKey = "cachedUserProgress"
    
    var userId: String? { Auth.auth().currentUser?.uid }
    
    init() {
        loadProgress()
    }
    
    func loadProgress() {
        guard let userId = userId else {
            loadFromCache()
            return
        }
        
        isLoading = true
        
        listener = db.collection("userProgress").document(userId)
            .addSnapshotListener { [weak self] document, error in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let error = error {
                    print("Error loading progress: \(error)")
                    self.loadFromCache()
                    return
                }
                
                if let document = document, document.exists {
                    if let data = document.data(),
                       let dishCompletions = data["dishCompletions"] as? [String: Int] {
                        
                        var progress = UserProgress(userId: userId)
                        progress.dishCompletions = dishCompletions
                        progress.lastUpdated = (data["lastUpdated"] as? Timestamp)?.dateValue() ?? Date()
                        
                        DispatchQueue.main.async {
                            self.userProgress = progress
                            self.saveToCache(progress)
                        }
                    }
                } else {
                    self.createNewProgress(userId: userId)
                }
            }
    }
    
    private func createNewProgress(userId: String) {
        var progress = UserProgress(userId: userId)
        
        for dishName in getAllDishNames() {
            progress.dishCompletions[dishName] = 0
        }
        
        db.collection("userProgress").document(userId).setData(progress.toDictionary())
        
        DispatchQueue.main.async {
            self.userProgress = progress
            self.saveToCache(progress)
        }
    }
    
    private func loadFromCache() {
        guard let data = UserDefaults.standard.data(forKey: localCacheKey) else {
            createDefaultProgress()
            return
        }
        
        do {
            let dishCompletions = try JSONDecoder().decode([String: Int].self, from: data)
            var progress = UserProgress(userId: userId ?? "local")
            progress.dishCompletions = dishCompletions
            self.userProgress = progress
        } catch {
            createDefaultProgress()
        }
    }
    
    private func saveToCache(_ progress: UserProgress) {
        do {
            let data = try JSONEncoder().encode(progress.dishCompletions)
            UserDefaults.standard.set(data, forKey: localCacheKey)
        } catch {
            print("Failed to save to cache: \(error)")
        }
    }
    
    private func createDefaultProgress() {
        var progress = UserProgress(userId: userId ?? "local")
        for dishName in getAllDishNames() {
            progress.dishCompletions[dishName] = 0
        }
        self.userProgress = progress
    }
    
    private func getAllDishNames() -> [String] {
        var allDishes: [String] = []
        allDishes += ChapterData.beijing.map { $0.name }
        allDishes += ChapterData.sichuan.map { $0.name }
        allDishes += ChapterData.jiangsu.map { $0.name }
        allDishes += ChapterData.minnan.map { $0.name }
        allDishes += ChapterData.guangdong.map { $0.name }
        allDishes += ChapterData.anhui.map { $0.name }
        return allDishes
    }
    
    func incrementCompletion(for dishName: String) {
        guard var progress = userProgress else { return }
        
        progress.dishCompletions[dishName] = (progress.dishCompletions[dishName] ?? 0) + 1
        progress.lastUpdated = Date()
        
        self.userProgress = progress
        saveToCache(progress)
        
        if let userId = userId {
            db.collection("userProgress").document(userId).updateData([
                "dishCompletions": progress.dishCompletions,
                "lastUpdated": Timestamp(date: Date())
            ])
        }
    }
    
    func badgeLevel(for dishName: String) -> BadgeLevel {
        return userProgress?.badgeLevel(for: dishName) ?? .none
    }
    
    var earnedBadges: [(dishName: String, level: BadgeLevel, count: Int)] {
        return userProgress?.earnedBadges ?? []
    }
    
    deinit {
        listener?.remove()
    }
}

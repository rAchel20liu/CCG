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
    private let localCacheKey = "cachedUserProgress_"
    
    // 不同账号用不同的缓存 key
    private var cacheKey: String {
        let userId = Auth.auth().currentUser?.uid ?? "anonymous"
        return localCacheKey + userId
    }
    
    private var userId: String? { Auth.auth().currentUser?.uid }
    
    // 监听 Auth 状态变化
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthListener()
        loadProgress()
    }
    
    // 监听登录状态变化
    private func setupAuthListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            // 用户切换时，重新加载数据
            DispatchQueue.main.async {
                self.clearLocalCache()
                self.loadProgress()
            }
        }
    }
    
    // 清除当前账号的缓存
    private func clearLocalCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
        userProgress = nil
    }
    
    func loadProgress() {
        guard let userId = userId else {
            // 未登录，清除数据
            userProgress = nil
            return
        }
        
        isLoading = true
        
        // 移除旧的监听器
        listener?.remove()
        
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
        
        db.collection("userProgress").document(userId).setData(progress.toDictionary()) { error in
            if let error = error {
                print("Error creating progress: \(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.userProgress = progress
            self.saveToCache(progress)
        }
    }
    
    private func loadFromCache() {
        guard let userId = userId else { return }
        
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
            createDefaultProgress()
            return
        }
        
        do {
            let dishCompletions = try JSONDecoder().decode([String: Int].self, from: data)
            var progress = UserProgress(userId: userId)
            progress.dishCompletions = dishCompletions
            self.userProgress = progress
        } catch {
            createDefaultProgress()
        }
    }
    
    private func saveToCache(_ progress: UserProgress) {
        do {
            let data = try JSONEncoder().encode(progress.dishCompletions)
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            print("Failed to save to cache: \(error)")
        }
    }
    
    private func createDefaultProgress() {
        guard let userId = userId else { return }
        var progress = UserProgress(userId: userId)
        for dishName in getAllDishNames() {
            progress.dishCompletions[dishName] = 0
        }
        self.userProgress = progress
    }
    
    private func getAllDishNames() -> [String] {
        return DataService.shared.dishes.map { $0.name }
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
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

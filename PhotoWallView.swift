//
//  PhotoWallView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/13.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct PhotoWallView: View {
    @StateObject private var photoVM = PhotoViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if photoVM.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if photoVM.photos.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 80))
                            .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51).opacity(0.5))
                        
                        Text("No photos yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Finish a dish and share your creation!")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(photoVM.photos) { photo in
                                NavigationLink {
                                    PhotoDetailView(photo: photo, onDelete: {
                                        // 删除后刷新列表
                                        photoVM.loadPhotos()
                                    })
                                } label: {
                                    VStack(spacing: 8) {
                                        CachedAsyncImage(url: URL(string: photo.imageUrl))
                                            .frame(width: 110, height: 110)
                                            .cornerRadius(12)
                                            .clipped()
                                        
                                        Text(photo.dishName)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                            .foregroundColor(.black)
                                        
                                        Text(formatDate(photo.uploadDate))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(width: 110)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.white)
            .navigationTitle("Photo Wall")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: date)
    }
}

// MARK: - Photo Detail View
struct PhotoDetailView: View {
    let photo: UserPhoto
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var isDeleting = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    CachedAsyncImage(url: URL(string: photo.imageUrl))
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                .background(Color.white)
                
                if isDeleting {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView()
                        .tint(.white)
                }
            }
            .navigationTitle(photo.dishName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Delete Photo", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deletePhoto()
                }
            } message: {
                Text("Are you sure you want to delete this photo?")
            }
        }
    }
    
    private func deletePhoto() {
        isDeleting = true
        
        guard let photoId = photo.id else {
            isDeleting = false
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            isDeleting = false
            return
        }
        
        // 1. 删除 Storage 中的图片
        let storageRef = Storage.storage().reference().child("userPhotos/\(userId)/\(photoId).jpg")
        storageRef.delete { error in
            if let error = error {
                print("Storage delete error: \(error)")
            }
            
            // 2. 删除 Firestore 中的文档
            let db = Firestore.firestore()
            db.collection("userPhotos").document(userId).collection("photos").document(photoId).delete { error in
                DispatchQueue.main.async {
                    isDeleting = false
                    
                    if let error = error {
                        print("Firestore delete error: \(error)")
                    } else {
                        // 清除缓存
                        if let url = URL(string: photo.imageUrl) {
                            ImageCache.shared.get(forKey: url.absoluteString)
                            UserDefaults.standard.removeObject(forKey: url.absoluteString)
                        }
                        
                        // 返回上一页并刷新列表
                        onDelete()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoWallView()
}

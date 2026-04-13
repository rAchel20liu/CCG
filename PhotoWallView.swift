//
//  PhotoWallView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/13.
//


import SwiftUI

struct PhotoWallView: View {
    @StateObject private var photoVM = PhotoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        // 使用 NavigationStack 自动处理导航栏和返回按钮
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
                                    PhotoDetailView(photo: photo)
                                } label: {
                                    VStack(spacing: 8) {
                                        AsyncImage(url: URL(string: photo.imageUrl)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 110, height: 110)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(12)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 110, height: 110)
                                                    .cornerRadius(12)
                                                    .clipped()
                                            case .failure:
                                                Image(systemName: "photo.fill")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.gray)
                                                    .frame(width: 110, height: 110)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(12)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        
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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: URL(string: photo.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    case .failure:
                        Image(systemName: "photo.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .background(Color.white)
            .navigationTitle(photo.dishName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoWallView()
}

//
//  CashedAsyncImage.swift
//  CCG
//
//  Created by H2026215 on 2026/4/17.
//


import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                if contentMode == .fill {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                // 加载中占位
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        let cacheKey = url.absoluteString
        
        // 先从内存缓存取
        if let cachedImage = ImageCache.shared.get(forKey: cacheKey) {
            image = cachedImage
            return
        }
        
        // 从磁盘缓存取
        if let diskCachedData = UserDefaults.standard.data(forKey: cacheKey),
           let diskCachedImage = UIImage(data: diskCachedData) {
            ImageCache.shared.set(diskCachedImage, forKey: cacheKey)
            image = diskCachedImage
            return
        }
        
        // 下载
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                ImageCache.shared.set(downloadedImage, forKey: cacheKey)
                UserDefaults.standard.set(data, forKey: cacheKey)
                image = downloadedImage
            }
        }.resume()
    }
}

// 支持 contentMode 的便捷初始化
extension CachedAsyncImage {
    func scaledToFit() -> some View {
        var view = self
        view.contentMode = .fit
        return view
    }
    
    func scaledToFill() -> some View {
        var view = self
        view.contentMode = .fill
        return view
    }
}

// 内存缓存
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

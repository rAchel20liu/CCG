//
//  PhotoWallView.swift
//  CCG
//
//  Created by H2026215 on 2026/2/27.
//

import SwiftUI

struct PhotoWallView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // 自定义导航栏
            HStack {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.title2)
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                }
                Spacer()
                Text("Photo Wall")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                Spacer()
                Color.clear.frame(width: 60) // 平衡返回按钮
            }
            .padding()
            
            Spacer()
            
            // 占位内容
            VStack(spacing: 20) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 80))
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51).opacity(0.5))
                
                Text("No photos yet")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Text("Upload photos of your dishes!")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}

#Preview {
    PhotoWallView()
}

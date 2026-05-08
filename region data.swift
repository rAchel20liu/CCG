//
//  region data.swift
//  CCG
//
//  Created by H2026215 on 2026/4/13.
//

//
//  region data.swift
//  CCG
//
//  Created by H2026215 on 2026/4/13.
//

import SwiftUI

struct RegionCard: View {
    let title: String
    let imageName: String
    // 删除了 dishes 参数
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 26))
                .fontWeight(.semibold)
                .padding(.leading, 20)
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(8)
                .clipped()
        }
        .padding(.horizontal, 10)
        .frame(width: 348, height: 153)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.34, green: 0.24, blue: 0.51), lineWidth: 3)
        )
    }
}

#Preview {
    RegionCard(title: "Beijing", imageName: "beijing")
}

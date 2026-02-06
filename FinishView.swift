//
//  RecipeCompleteView.swift
//  CCG
//
//  Created by H2026215 on 2026/1/30.
//
import SwiftUI

struct FinishView: View {
    let onSkip: () -> Void  // 🔹 新增：外部传入跳出flow的闭包

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()  // 🔹 背景白色

            VStack(spacing: 40) {
                Spacer()

                Text("Congratulations！\n\nYou’ve finished the\n dish of this level!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    .multilineTextAlignment(.center)

                Text("🎉")
                    .font(.system(size: 100))
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))

                Spacer()

                Button(action: {
                    // 可以加上传逻辑
                }) {
                    Text("Upload Image")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }

                Button(action: {
                    onSkip()   // 🔹 点击 Skip 调用闭包退出 RecipeFlowView
                }) {
                    Text("Skip")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }

                Spacer().frame(height: 50)
            }
        }
    }
}

#Preview {
    FinishView {
        print("Skip pressed, should dismiss RecipeFlowView")
    }
}

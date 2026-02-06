//
//  RecipeStepPage.swift
//  CCG
//
//  Created by H2026215 on 2026/1/26.
//
import SwiftUI

struct RecipeStepPage: View {
    let step: RecipeStep
    let onNext: () -> Void
    let onQuit: () -> Void

    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.34, green: 0.24, blue: 0.51)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 🔹 顶部文字直接贴顶
                VStack(alignment: .leading, spacing: 12) {
                    Text("Step \(step.stepNumber). \(step.title)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .padding(.top, safeAreaTop() + 16)
                        .padding(.horizontal, 24)

                    Text(step.description)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .lineSpacing(10)
                        .padding(.horizontal, 24)
                }

                Spacer() // 推动内容到顶部

                // Next Button
                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .cornerRadius(1000)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }

    // 获取安全区顶部高度（适配灵动岛）
    private func safeAreaTop() -> CGFloat {
        let keyWindow = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.top ?? 44
    }
}

#Preview {
    RecipeStepPage(
        step: DishData.zhajiangMian.recipesteps.first!,
        onNext: {},
        onQuit: {}
    )
}

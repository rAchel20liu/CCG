//
//  RecipeFlowView.swift
//  CCG
//
//  Created by H2026215 on 2026/1/26.
//

import SwiftUI

struct RecipeFlowView: View {
    let dish: DishInfo
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep = 0
    @State private var showFinish = false   // 🔹 新增：是否显示完成页

    var body: some View {
        ZStack {
            if showFinish {
                // ✅ Finish 页：纯白
                FinishView{
                    dismiss()
                }
                .background(Color.white.ignoresSafeArea())
            } else {
                // ✅ Step 页：紫色背景
                Color(red: 0.34, green: 0.24, blue: 0.51)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 顶部按钮
                    HStack(spacing: 16) {
                        Button {
                            if currentStep > 0 {
                                currentStep -= 1
                            } else {
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(1000)
                            .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                        }

                        Button {
                            dismiss()
                        } label: {
                            Text("Quit")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(1000)
                                .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                        }

                        Spacer()
                    }
                    .padding(.top, safeAreaTop() + 8)
                    .padding(.horizontal, 16)

                    Spacer()

                    RecipeStepPage(
                        step: dish.recipesteps[currentStep],
                        onNext: {
                            if currentStep < dish.recipesteps.count - 1 {
                                currentStep += 1
                            } else {
                                showFinish = true   // ⭐ 切到 Finish
                            }
                        },
                        onQuit: {
                            dismiss()
                        }
                    )

                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }

    // 获取安全区顶部高度
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
    NavigationStack {
        RecipeFlowView(dish: DishData.zhajiangMian)
    }
}

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
            Color(red: 0.34, green: 0.24, blue: 0.51)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                   
                Spacer().frame(height: 20)
                
                // 步骤文字
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Step \(step.stepNumber). \(step.title)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(nil)
                        
                        Text(step.description)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                            .lineSpacing(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // 倒计时区域 - 使用独立的 Timer 组件
                if let timerDuration = step.timerDuration, timerDuration > 0 {
                    StepTimerView(duration: timerDuration, onComplete: {
                        onNext()  // 倒计时结束自动下一步
                    })
                    .padding(.bottom, 30)
                }
                
                // Next 按钮
                Button(action: {
                    onNext()
                }) {
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
    
    private func safeAreaTop() -> CGFloat {
        let keyWindow = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.top ?? 44
    }
}

#Preview("With Timer") {
    let stepWithTimer = RecipeStep(
        stepNumber: 2,
        title: "Fry the Zhajiang Sauce",
        description: "Pour the remaining cooking oil into the pan; when the oil is hot, add minced ginger and half the chopped scallions, stir-fry until fragrant; add pork belly cubes and stir-fry until the meat turns white and releases oil.",
        timerDuration: 120
    )
    
    return RecipeStepPage(
        step: stepWithTimer,
        onNext: { print("Next pressed") },
        onQuit: { print("Quit pressed") }
    )
}

#Preview("Without Timer") {
    let stepWithoutTimer = RecipeStep(
        stepNumber: 1,
        title: "Prepare",
        description: "Cut ingredients into small pieces.",
        timerDuration: nil
    )
    
    return RecipeStepPage(
        step: stepWithoutTimer,
        onNext: { print("Next pressed") },
        onQuit: { print("Quit pressed") }
    )
}

//
//  Timer.swift
//  CCG
//
//  Created by H2026215 on 2026/3/23.
//

//
//  StepTimerView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/23.
//
//
//  StepTimerView.swift
//  CCG
//
//  Created by H2026215 on 2026/3/23.
//

import SwiftUI

struct StepTimerView: View {
    let duration: Int
    let onComplete: () -> Void
    
    // 用 @State 确保每个实例独立
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var isRunning = false
    
    init(duration: Int, onComplete: @escaping () -> Void) {
        self.duration = duration
        self.onComplete = onComplete
        _timeRemaining = State(initialValue: duration)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 8)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.white, lineWidth: 8)
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: progress)
                
                Text(formatTime(timeRemaining))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 40) {
                Button(action: toggleTimer) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                
                Button(action: resetTimer) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
            }
            
            Text("Tap NEXT to skip timer")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var progress: CGFloat {
        return 1 - CGFloat(timeRemaining) / CGFloat(duration)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        } else {
            return "\(seconds)"
        }
    }
    
    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        guard timeRemaining > 0 else { return }
        
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    
                    if self.timeRemaining == 0 {
                        self.stopTimer()
                        self.onComplete()
                    }
                } else {
                    self.stopTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    private func resetTimer() {
        stopTimer()
        timeRemaining = duration
    }
}

#Preview {
    ZStack {
        Color(red: 0.34, green: 0.24, blue: 0.51)
            .ignoresSafeArea()
        
        StepTimerView(duration: 120) {
            print("Timer completed!")
        }
    }
}

//
//  CircularProgress.swift
//  PomodoroTimer
//
//  Created by Angel Hernández Gámez on 25/07/25.
//

import SwiftUI

struct CircularProgress: View {
    let workProgress: Double
    let breakProgress: Double
    let isBreak: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.tint.tertiary, lineWidth: 30)
            // Work timer arc
            Circle()
                .trim(to: workProgress)
                .stroke(.tint, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring, value: workProgress)
                .zIndex(isBreak ? 0 : 1)
            // Break timer arc
            Circle()
                .trim(to: breakProgress)
                .stroke(.orange, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring, value: breakProgress)
                .zIndex(isBreak ? 1 : 0)
        }
        .transaction { transaction in
            // Disable animation when resetting progress to zero
            if (!isBreak && workProgress == 0) || (isBreak && breakProgress == 0) {
                transaction.disablesAnimations = true
            }
        }
    }
}

#Preview {
    CircularProgress(workProgress: 0.25, breakProgress: 0.0, isBreak: true)
        .frame(width: 250, height: 250)
}

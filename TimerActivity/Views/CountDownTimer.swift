//
//  CountDownTimer.swift
//  PomodoroTimer
//
//  Created by Angel Hernández Gámez on 25/07/25.
//

import SwiftUI

struct CountDownTimer: View {
    let timeRemaining: Int
    let isOnBreak: Bool
    
    var titleFont: Font = .headline
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isOnBreak ? "Descanso" : "Trabajo")
                .font(titleFont)
            HStack(spacing: 0) {
                Text("\(timeRemaining / 3600, specifier: "%02d"):")
                Text("\((timeRemaining / 60) % 60, specifier: "%02d"):")
                Text("\(timeRemaining % 60, specifier: "%02d")")
            }
            .font(.largeTitle)
            .bold()
            .contentTransition(.numericText())
            .monospaced()
            .foregroundStyle(
                timeRemaining < 10 && timeRemaining % 2 == 0
                ? isOnBreak ? .mint : .orange
                : .primary
            )
        }
    }
}

#Preview {
    CountDownTimer(timeRemaining: 7, isOnBreak: true)
}

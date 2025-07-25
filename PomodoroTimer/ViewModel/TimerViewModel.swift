//
//  TimerViewModel.swift
//  PomodoroTimer
//
//  Created by Angel Hernández Gámez on 25/07/25.
//

import Foundation
import SwiftUI
import ActivityKit

class TimerViewModel: ObservableObject {
    @Published var timerProgress: Double = 0
    @Published var breakProgress: Double = 0
    @Published var timer: Timer?
    @Published var isRunning = false
    @Published var totalSecs: Int = 0
    @Published var selectedTime: ChoosedTime = ChoosedTime(hour: 0, minutes: 25, seconds: 0)
    @Published var selectedBreak: ChoosedTime = ChoosedTime(hour: 0, minutes: 5, seconds: 0)
    @Published var isOnBreak = false
    
    private var liveActivity: Activity<TimerActivityAttributes>? = nil
    
    func clean() {
        timerProgress = 0
        breakProgress = 0
        totalSecs = 0
        isOnBreak = false
        timer?.invalidate()
        Task {
            await liveActivity?.end(dismissalPolicy: .immediate)
        }
    }
    
    func buttonStartTime() {
        guard !isRunning else { return }
        guard calculateTime(selectedTime) > 0 else { return }
        guard calculateTime(selectedBreak) > 0 else { return }
        timerProgress = 0
        breakProgress = 0
        totalSecs = 0
        isOnBreak = false
        timer?.invalidate()
        Task { @MainActor in
            do {
                let attributes = TimerActivityAttributes(name: "Pomodoro")
                let initialState = TimerActivityAttributes.ContentState(timeRemaining: calculateTime(selectedTime), isOnBreak: isOnBreak)
                liveActivity = try Activity.request(attributes: attributes, contentState: initialState)
                self.startTimer()
            } catch {
                print("Live Activity request failed: \(error)")
            }
        }
    }
    
    private func scheduleTimer(duration: Int, isBreak: Bool) {
        let totalSeconds = Double(duration)
        var elapsed = 0.0
        var helper = 0
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsed += 0.1
            helper += 1
            
            if helper == 10 {
                withAnimation {
                    self.totalSecs -= 1
                }
                Task {
                    await self.liveActivity?.update(using:
                                                        TimerActivityAttributes.ContentState(
                                                            timeRemaining: self.totalSecs,
                                                            isOnBreak: isBreak
                                                        )
                    )
                }
                helper = 0
            }
            
            if isBreak {
                self.breakProgress = elapsed / totalSeconds
            } else {
                self.timerProgress = elapsed / totalSeconds
            }
            
            if elapsed >= totalSeconds {
                self.timer?.invalidate()
                if isBreak {
                    self.isOnBreak = false
                    self.timerProgress = 0
                    self.startTimer()
                } else {
                    self.breakProgress = 0
                    self.startBreak()
                }
            }
        }
    }
    
    func stopTimer() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        Task {
            await liveActivity?.end(dismissalPolicy: .immediate)
        }
    }
}

extension TimerViewModel {
    private func startTimer() {
        isRunning = true
        totalSecs = calculateTime(selectedTime)
        scheduleTimer(duration: totalSecs, isBreak: false)
    }
    
    private func startBreak() {
        guard !isOnBreak else { return }
        isOnBreak = true
        totalSecs = calculateTime(selectedBreak)
        scheduleTimer(duration: totalSecs, isBreak: true)
    }
}

extension TimerViewModel {
    private func calculateTime(_ selectedTime: ChoosedTime) -> Int {
        var totalSecs = selectedTime.seconds
        totalSecs += selectedTime.minutes * 60
        totalSecs += selectedTime.hour * 3600
        
        return totalSecs
    }
}

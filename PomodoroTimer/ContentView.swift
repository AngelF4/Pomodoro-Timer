//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Angel Hernández Gámez on 25/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TimerViewModel()
    var body: some View {
        ZStack {
            Group {
                if !viewModel.isRunning {
                    
                } else if viewModel.isOnBreak {
                    Color.orange.opacity(0.05)
                        .ignoresSafeArea()
                } else {
                    Color.accentColor.opacity(0.05)
                        .ignoresSafeArea()
                }
            }
            .transition(.opacity)
            VStack {
                if !viewModel.isRunning {
                    VStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Trabajar durante")
                                .font(.headline)
                            TimerSelector(selectedTime: $viewModel.selectedTime)
                                .frame(height: 150)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Descansar")
                                .font(.headline)
                            TimerSelector(selectedTime: $viewModel.selectedBreak)
                                .frame(height: 150)
                        }
                    }
                    .transition(.opacity)
                } else {
                    VStack {
                        Text(viewModel.isOnBreak ? "Descanso" : "Trabajo")
                            .font(.title2.bold())
                            .animation(.spring, value: viewModel.isOnBreak)
                            .contentTransition(.numericText())
                            .padding()
                        CircularProgress(
                            workProgress: viewModel.timerProgress,
                            breakProgress: viewModel.breakProgress,
                            isBreak: viewModel.isOnBreak
                        )
                        .frame(width: 300, height: 300)
                        .overlay {
                            HStack(spacing: 0) {
                                Text("\(viewModel.totalSecs / 3600, specifier: "%02d"):")
                                Text("\((viewModel.totalSecs / 60) % 60, specifier: "%02d"):")
                                Text("\(viewModel.totalSecs % 60, specifier: "%02d")")
                            }
                            .font(.title)
                            .bold()
                            .contentTransition(.numericText())
                            .monospaced()
                        }
                    }
                    .transition(.blurReplace)
                }
            }
            .onChange(of: viewModel.isRunning) { isRunning in
                if !isRunning {
                    viewModel.clean()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        withAnimation {
                            viewModel.stopTimer()
                        }
                    } label: {
                        Text("Reset")
                            .frame(width: 70, height: 70)
                    }
                    .tint(.red)
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.buttonStartTime()
                        }
                    } label: {
                        Text("Start")
                            .frame(width: 70, height: 70)
                    }
                    .tint(.green)
                    
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}

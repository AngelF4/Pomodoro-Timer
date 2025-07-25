//
//  TimerSelector.swift
//  PomodoroTimer
//
//  Created by Angel Hernández Gámez on 25/07/25.
//

import SwiftUI

struct TimerSelector: View {
    @Binding var selectedTime: ChoosedTime
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    var body: some View {
        HStack(spacing: 0) {
            Picker(selection: $selectedTime.hour) {
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour) \(hour == 1 ? "hora" : "horas")")
                }
            } label: {
                Text("Horas")
            }
            Picker(selection: $selectedTime.minutes) {
                ForEach(minutes, id: \.self) { minute in
                    Text("\(minute) \(minute == 1 ? "minuto" : "minutos")")
                }
            } label: {
                Text("Minutos")
            }
            Picker(selection: $selectedTime.seconds) {
                ForEach(seconds, id: \.self) { second in
                    Text("\(second) s")
                }
            } label: {
                Text("S")
            }
        }
        .pickerStyle(.wheel)
    }
}

#Preview {
    @Previewable @State var selectedTime: ChoosedTime = ChoosedTime(hour: 0, minutes: 5, seconds: 0)
    TimerSelector(selectedTime: $selectedTime)
}

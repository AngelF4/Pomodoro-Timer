//
//  TimerActivityLiveActivity.swift
//  TimerActivity
//
//  Created by Angel Hernández Gámez on 25/07/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var timeRemaining: Int
        var isOnBreak: Bool
    }
    
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimerActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading, spacing: 24) {
                Text("Pomodoro Timer")
                    .bold()
                HStack(spacing: 40) {
                    Image(systemName: context.state.isOnBreak ? "beach.umbrella" : "briefcase")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundStyle(context.state.isOnBreak ? .orange : .mint)
                    
                    CountDownTimer(
                        timeRemaining: context.state.timeRemaining,
                        isOnBreak: context.state.isOnBreak,
                        titleFont: .title3
                    )
                }
                
            }
            .activityBackgroundTint(Color.white.opacity(0.8))
            .activitySystemActionForegroundColor(Color.black)
//            .frame(height: 175)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(32)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.isOnBreak ? "beach.umbrella" : "briefcase")
                        .foregroundStyle(context.state.isOnBreak ? .orange : .mint)
                        .padding(.horizontal)
                }
                DynamicIslandExpandedRegion(.trailing) {

                }
                DynamicIslandExpandedRegion(.bottom) {
                    CountDownTimer(
                        timeRemaining: context.state.timeRemaining,
                        isOnBreak: context.state.isOnBreak
                    )
                }
            } compactLeading: {
                Image(systemName: context.state.isOnBreak ? "beach.umbrella" : "briefcase")
                    .foregroundStyle(context.state.isOnBreak ? .orange : .mint)
            } compactTrailing: {
                let hours = context.state.timeRemaining / 3600
                let minutes = (context.state.timeRemaining / 60) % 60
                let seconds = context.state.timeRemaining % 60
                
                HStack(spacing: 0) {
                    if hours > 0 {
                        Text("\(hours)")
                        Text(":")
                    }
                    Text(String(format: "%02d", minutes))
                    Text(":")
                    Text(String(format: "%02d", seconds))
                }
                .bold()
                .contentTransition(.numericText())
                .monospaced()
                .foregroundStyle(
                    context.state.timeRemaining < 10 && context.state.timeRemaining % 2 == 0
                    ? context.state.isOnBreak ? .mint : .orange
                    : .primary
                )
            } minimal: {
                Image(systemName: context.state.isOnBreak ? "beach.umbrella" : "briefcase")
                    .foregroundStyle(context.state.isOnBreak ? .orange : .mint)
                    .padding(2.5)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerActivityAttributes {
    fileprivate static var preview: TimerActivityAttributes {
        TimerActivityAttributes(name: "Pomodoro")
    }
}

extension TimerActivityAttributes.ContentState {
    fileprivate static var state1: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(timeRemaining: 7, isOnBreak: true)
    }
    
    fileprivate static var state2: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(timeRemaining: 8, isOnBreak: false)
    }
    
    fileprivate static var state3: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(timeRemaining: 8, isOnBreak: true)
    }
}

#Preview("Notification", as: .content, using: TimerActivityAttributes.preview) {
    TimerActivityLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.state1
    TimerActivityAttributes.ContentState.state2
    TimerActivityAttributes.ContentState.state3
}

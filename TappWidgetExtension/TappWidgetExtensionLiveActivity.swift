//
//  TappWidgetExtensionLiveActivity.swift
//  TappWidgetExtension
//
//  Created by Adam Shulman on 17/03/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TappWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TappWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TappWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TappWidgetExtensionAttributes {
    fileprivate static var preview: TappWidgetExtensionAttributes {
        TappWidgetExtensionAttributes(name: "World")
    }
}

extension TappWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: TappWidgetExtensionAttributes.ContentState {
        TappWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TappWidgetExtensionAttributes.ContentState {
         TappWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TappWidgetExtensionAttributes.preview) {
   TappWidgetExtensionLiveActivity()
} contentStates: {
    TappWidgetExtensionAttributes.ContentState.smiley
    TappWidgetExtensionAttributes.ContentState.starEyes
}

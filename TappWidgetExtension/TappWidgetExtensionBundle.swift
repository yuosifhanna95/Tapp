//
//  TappWidgetExtensionBundle.swift
//  TappWidgetExtension
//
//  Created by Adam Shulman on 17/03/2025.
//

import WidgetKit
import SwiftUI

@main
struct TappWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WheelOfCoinsWidget()
        TappWidgetExtensionControl()
        TappWidgetExtensionLiveActivity()
    }
}

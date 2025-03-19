//
//  TappWidgetApp.swift
//  TappWidget
//
//  Created by Adam Shulman on 17/03/2025.
//

import SwiftUI
import WidgetKit

@main
struct TappWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { incomingURL in
                    UserDefaults.init(suiteName: "group.com.CompanyYH.TappWidget.TappWidgetExtension")?.set(true, forKey: "WOCClaimButtonClicked")
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        
    }
}

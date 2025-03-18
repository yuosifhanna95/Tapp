//
//  SpinWheelView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 13/03/2025.
//


//
//  SpinViewWheel2.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 09/03/2025.
//

//
//  SpinWheelView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 03/01/2025.
//
//move to structs

import SwiftUI
import WidgetKit
import AppIntents

//@available(iOS 17, *)
//struct SpinWheelView: View {
//    
//    var entry: SpinEntry
//    let circleFrame: CGFloat = 145 * WheelGameManager.shared.scaler
//    var body: some View {
//        ZStack {
//            switch entry.state {
//            case .start, .spinning:
//                WheelView(entry: entry)
//            case .collect, .unAvailable:
//                SpinUnavailableView(entry: entry)
//            case .noNetwork:
//                SpinUnavailableView(entry: entry)
//            }
//        }
//        .overlay {
//            Text("\(entry.state)")
//                .padding(.top, 100)
//            Text("P: \(TimeLineManager.shared.previousTimeLineType)")
//                .padding(.bottom, 100)
//            Text("C: \(TimeLineManager.shared.timeLineType)")
//                .padding(.bottom, 60)
//        }
//        .containerBackground(Color.clear, for: .widget)
//        .widgetURL(URL(string: ExtensionManager.shared.getWidgetURL(entry: entry, claimView: false))!)
//    }
//}


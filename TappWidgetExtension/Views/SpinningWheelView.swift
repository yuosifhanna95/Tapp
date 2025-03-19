//
//  SpinningWheelView.swift
//  Unity-iPhone
//
//  Created by Adam Shulman on 17/03/2025.
//

import SwiftUICore

struct SpinningWheelView: View {
    
    let entry: SpinEntry
    let spinningModel: SpinningWheelStateModel?
    
    private let scaler = WheelGameManager.shared.scaler
    private let circleFrame = 145.0
    
    private var firstSparksOpacity: CGFloat {
        return spinningModel?.firstOpacity ?? 0.0
    }
    
    private var secondSparksOpacity: CGFloat {
        return spinningModel?.secondOpacity ?? 0.0
    }
    
    private var rotation: CGFloat {
        return spinningModel?.rotationAngle ?? 360.0
    }
    
    var body: some View {
        ZStack {

            WheelFrameView(circleFrame: circleFrame, rotation: rotation, prizes: PrizeManager.shared.prizes, scaler: scaler)
            
            OuterFrameView(circleFrame: circleFrame)
            
            SpinButtonView(entry: entry, scaler: scaler, opacity: 1.0, isDisabled: false)
            
            SparksView(firstSparkOpacity: firstSparksOpacity, secondSparkOpacity: secondSparksOpacity)
        }
//        .background(content: {
//            
//            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.0), scaler: scaler)
//            
//            
//        })
        
        .containerBackground(for: .widget, content: {
            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.5), scaler: scaler)
        })
    }
}

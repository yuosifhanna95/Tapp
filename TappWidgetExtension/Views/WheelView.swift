//
//  WheelView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//
import SwiftUI
import AppIntents

@available(iOS 17, *)
struct WheelView : View {
    
    let entry: SpinEntry
    let spinningModel: SpiningWheelStateModel?
    
    private let scaler = WheelGameManager.shared.scaler
    private let rotation = 360.0
    private let circleFrame = 150.0
    
    private var firstSparksOpacity: CGFloat {
        return spinningModel?.firstOpacity ?? 0.0
    }
    
    private var secondSparksOpacity: CGFloat {
        return spinningModel?.secondOpacity ?? 0.0
    }
    
    var body: some View {
        ZStack {

            //------------------------------------- Wheel Frame
            
            WheelFrameView(circleFrame: circleFrame, rotation: rotation, prizes: PrizeManager.shared.prizes, scaler: scaler)
            
            //------------------------------------- Outer Frame
            
            OuterFrameView(circleFrame: circleFrame)
            
            
            //------------------------------------- Spin Button
            
            SpinButtonView(entry: entry, scaler: scaler, opacity: 1.0, isDisabled: false)
            
                        
            SparksView(firstSparkOpacity: firstSparksOpacity, secondSparkOpacity: secondSparksOpacity)
        }
        
        
        
//        .background(content: {
//            
//            //------------------------------------- Background
//            
//            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.0), scaler: scaler)
//            
//            
//            
//        })
        .containerBackground(for: .widget, content: {
            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.0), scaler: scaler)
        })
//        .containerBackground(.black, for: .widget)
        //MARK: There is a special view for no network state
//        .overlay {
//            if(!entry.networkAvailable) {
//                NoNetworkView(entry: entry)
//            }
//        }
    }
}

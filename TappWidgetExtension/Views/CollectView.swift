//
//  CollectView.swift
//  TappWidget
//
//  Created by Yuosif Hanna on 19/03/2025.
//

import SwiftUI
import AppIntents

@available(iOS 17, *)
struct CollectView : View {
    
    let entry: SpinEntry
    let spinningModel: SpinningWheelStateModel?
    private let circleFrame = CGFloat(145.0)
    private let rotation = CGFloat(360.0)
    private let scaler = WheelGameManager.shared.scaler
    
    var body: some View {
        ZStack {
            //------------------------------------- Wheel Frame
                        
            WheelFrameView(circleFrame: circleFrame, rotation: spinningModel?.rotationAngle ?? rotation, prizes: PrizeManager.shared.prizes, scaler: scaler)
            
            
            //------------------------------------- Outer Frame
            
            OuterFrameView(circleFrame: circleFrame)
            
            
            //------------------------------------- Spin Button
            
            SpinButtonView(entry: entry, scaler: scaler, opacity: 0.5, isDisabled: false)
                .disabled(true)
            
        }
//        .background(content: {
//
//            //------------------------------------- Background
//
//            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.0), scaler: scaler)
//
////            BackgroundImageView(entry: entry)
////                .scaledToFill()
//
//        })
        .overlay {
            SparksView(firstSparkOpacity: spinningModel?.firstOpacity ?? 1.0, secondSparkOpacity: spinningModel?.secondOpacity ?? 0.001)
        }
        .overlay(Color.black.opacity(0.45)
            .frame(width: 200, height: 200, alignment: .center))
        .overlay {
            
            //MARK: CHECK THIS:
            
            ClaimRewardView(selectedImagePrize: PrizeManager.shared.selectedImagePrize, scaler: scaler, destinationUrl: URL(string: ExtensionManager.shared.getWidgetURL(entry: entry, claimView: true))!)
            
            //DigitalClockView(lastSpinDate: entry.date, spinTime: WheelGameManager.shared.spinTime)
            
        }
        .overlay {
            
            //MARK: This view excpects to be when network is available.
            
//            if(!entry.networkAvailable) {
//                NoNetworkView(entry: entry)
//            }
        }
        .containerBackground(for: .widget, content: {
            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.0), scaler: scaler)
        })
    }
}

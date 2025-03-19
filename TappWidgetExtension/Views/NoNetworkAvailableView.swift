//
//  NoNetworkAvailableView.swift
//  TappWidget
//
//  Created by Yuosif Hanna on 19/03/2025.
//
import SwiftUI

@available(iOS 17, *)
struct NoNetworkAvailableView : View {
    
    let entry: SpinEntry
    let prizes: [String]
    private let circleFrame = CGFloat(145.0)
    private let rotation = CGFloat(360.0)
    private let scaler = WheelGameManager.shared.scaler
    private let lastSpinDate = WheelGameManager.shared.lastSpinDate
    private let spinTime = WheelGameManager.shared.spinTime

    
    var body: some View {
        ZStack {
            //------------------------------------- Wheel Frame
                        
            WheelFrameView(circleFrame: circleFrame, rotation: rotation, prizes: prizes, scaler: scaler)
            
            
            //------------------------------------- Outer Frame
            
            OuterFrameView(circleFrame: circleFrame)
            
            
            //------------------------------------- Spin Button
            
            SpinButtonView(entry: entry, scaler: scaler, opacity: 0.5, isDisabled: true)
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
        
        //MARK: Sparks view when there is no internet?>
//        .overlay {
//            SparksView(entry: entry)
//        }
        .overlay(content: {
            NoNetworkView(scaler: scaler)
            
        })

        
        
//            .frame(width: 200, height: 200, alignment: .center)
//        .overlay {
//            //MARK: No Network View
//            
////            if(entry.networkAvailable) {
////                if(entry.state == .collect) {
////                    ClaimRewardView(entry: entry)
////                }
////                else if(entry.state == .unAvailable) {
////                    DigitalClockView()
////                }
////            }
//        }
//        .overlay {
//            
//            //MARK: No Network View
//            NoNetworkView(scaler: scaler)
//            
////            if(!entry.networkAvailable) {
////                NoNetworkView(entry: entry)
////            }
//        }
//        
        .containerBackground(for: .widget, content: {
            BackgroundImageView(rotation: rotation, duration: TimeInterval(1.5), scaler: scaler)
        })
    }
}


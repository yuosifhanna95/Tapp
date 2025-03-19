//
//  WheelFrameView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//
import SwiftUI

struct WheelFrameView : View {
    
    let circleFrame: CGFloat
    let rotation: CGFloat
    let prizes: [String]
    let scaler: CGFloat
    
    var body: some View {
        ZStack {
            //------------------------------------- Wheel
            
            Image("wheel", bundle: .main)
                .resizable()
                .frame(width: circleFrame - 10,height: circleFrame - 10)
            
            //------------------------------------- Prize Images
            
            CircularImagesView(circleFrame: circleFrame, scaler: scaler, width: 19.0, height: 19.0, prizes: prizes)
            
        }
        .rotationEffect(.degrees(rotation)) // Apply full rotation
        .animation(.spring(duration: 1.5), value: rotation)//entry.rotation
    }
}

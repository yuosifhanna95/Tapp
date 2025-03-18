//
//  CircularImagesView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//

import SwiftUI

struct CircularImagesView : View {
    
    let circleFrame: CGFloat
    let scaler: CGFloat
    let width: CGFloat
    let height: CGFloat
    let prizes: [String]
    
    private var frameWidth: CGFloat {
        return width * scaler
    }
    
    private var frameHeight: CGFloat {
        return height * scaler
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<prizes.count, id: \.self) { index in
                Image(prizes[index], bundle: .main)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .offset(x: 0, y: -48 * scaler) // Radius of the circle
                    .rotationEffect(.degrees(Double(index) / Double(prizes.count) * 360))
            }
        }
        .frame(width: circleFrame, height: circleFrame)
    }
}

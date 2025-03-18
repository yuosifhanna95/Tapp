//
//  ClaimRewardView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//
import SwiftUI

struct ClaimRewardView : View {
    
    let selectedImagePrize: Image?
    let scaler: CGFloat
    let destinationUrl: URL
    
    var body: some View {
        Link(destination: destinationUrl) {
            Image("collect", bundle: .main)
            .resizable()
            .scaledToFill()
            .frame(width: 80 * scaler, height: 40 * scaler)
            .overlay(alignment: .trailing) {
                if let prizeImage = selectedImagePrize {
                    prizeImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15 * scaler, height: 15 * scaler)
                    .offset(x: 15 * scaler)
                }
                
            }
        }
    }
}

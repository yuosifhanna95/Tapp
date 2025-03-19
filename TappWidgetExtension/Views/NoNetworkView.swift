//
//  NoNetworkView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//
import SwiftUI

@available(iOS 17, *)
struct NoNetworkView : View {
    
    //MARK: remove scaler and set locally font size
    let scaler: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.45))
            .frame(width: WheelGameManager.shared.width, height: WheelGameManager.shared.height)
        
        //.overlay()
        //.overlay(Color.black.opacity(!entry.networkAvailable ? 0.45 : 0)
//            .frame(width: 200, height: 200, alignment: .center))
        Text("Network Unavailable")
            .font(Font.custom(Font.wheelOfCoinsWidgetFontName, size: 20))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.bottom, 50 * scaler)
        Button(intent: RefreshNetworkWOCIntent()) {
            Text("Refresh")
                .font(Font.custom(Font.wheelOfCoinsWidgetFontName, size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
        .padding(.top, 50 * scaler)
    }
}

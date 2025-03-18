//
//  SpinButtonView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//

import SwiftUI
import AppIntents

struct SpinButtonView : View {
    
    let entry: SpinEntry
    let scaler: CGFloat
    let opacity: CGFloat
    let isDisabled: Bool
    
    var body: some View {
        ZStack {
            
            Image("pointerspin", bundle: .main)
                .resizable()
                .scaledToFill()
                .frame(width: 55 * scaler, height: 55 * scaler)
                .shadow(radius: 2)
                .padding(.bottom, 5 * scaler)
                .opacity(opacity)
            Button(intent: SpinIntent()) {
                
                Image("pointerspin", bundle: .main)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55 * scaler, height: 55 * scaler)
                    .shadow(radius: 2)
                
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)
            .padding(.bottom, 5 * scaler)
        }
    }
}

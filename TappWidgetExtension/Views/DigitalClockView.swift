//
//  DigitalClockView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//
import SwiftUI

struct DigitalClockView : View {
    
    let lastSpinDate: Date
    let spinTime: TimeInterval
    
    var body: some View {
        ZStack {
            Image("spinagainin", bundle: .main)
                .resizable()
                .frame(width: 152, height: 64)
                .padding(.bottom, 24)
            Text("\(timerInterval: lastSpinDate...Date(timeInterval: spinTime, since: lastSpinDate))")
                .font(Font.custom(Font.wheelOfCoinsWidgetFontName, size: 30))
                .multilineTextAlignment(.center)
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 5)
                .padding(.top, 5)
                .overlay {
                    Text("\(timerInterval: lastSpinDate...Date(timeInterval: spinTime, since: lastSpinDate))")
                        .font(Font.custom(Font.wheelOfCoinsWidgetFontName, size: 30))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
        }
    }
}

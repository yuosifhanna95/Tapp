//
//  BackgroundImageView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//

import SwiftUI

struct BackgroundImageView : View {
    
    let rotation: Double
    let duration: TimeInterval
    let scaler: CGFloat
    
    var body: some View {
        //MARK: Suppose this is a backgroundImage ( full size ) we can use here the geometry reader to set the size
        ZStack(){
            Image("bg", bundle: .main)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
//                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
//                    .position(CGPoint(x: 50, y: 50))
            Image("glow", bundle: .main)
                .resizable()
                .scaledToFill()
//                .aspectRatio(contentMode: .fill)
//                        .frame(width: geometry.size.width * 1.5 , height: geometry.size.height * 1.5)
                .rotationEffect(.degrees(rotation / 60))
                .animation(.spring(duration: duration), value: rotation) // MARK: duration variable, check if it can be set inside this view locally, if it doesnt change from outside for different durations.
            
            Image("fx", bundle: .main)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
//                        .frame(width: 115 * scaler, height: 160 * scaler) //MARK: magic numbers
            
        }
//        ZStack{
//            Image("bg", bundle: .main)
//                .resizable()
//                .scaledToFill()
//                .aspectRatio(contentMode: .fill)
////                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
////                    .position(CGPoint(x: 50, y: 50))
//            Image("glow", bundle: .main)
//                .resizable()
//                .scaledToFill()
//                .aspectRatio(contentMode: .fill)
////                    .frame(width: geometry.size.width * 1.5 , height: geometry.size.height * 1.5)
//                .rotationEffect(.degrees(rotation / 60))
//                .animation(.spring(duration: duration), value: rotation) // MARK: duration variable, check if it can be set inside this view locally, if it doesnt change from outside for different durations.
//            
//            Image("fx", bundle: .main)
//                .resizable()
//                .scaledToFill()
//                .aspectRatio(contentMode: .fill)
////                    .frame(width: 115 * scaler, height: 160 * scaler) //MARK: magic numbers
//            
//        }
//        
    }
}

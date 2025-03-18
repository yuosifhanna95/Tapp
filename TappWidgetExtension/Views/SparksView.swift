//
//  SparksView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//
import SwiftUI

struct SparksView : View {
    
    let firstSparkOpacity: Double
    let secondSparkOpacity: Double
    
    var body: some View {
        
        //MARK: This view can give you the size of the widget.
        GeometryReader { geometry in
            ZStack {
                //first sparks shown
                
                Image("sparks", bundle: .main)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 20, height: geometry.size.height - 20)
                    .opacity(firstSparkOpacity)
                    .animation(.spring(duration: 1), value: firstSparkOpacity)
                
                Image("sparks", bundle: .main)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 20, height: geometry.size.height - 20)
                    .opacity(secondSparkOpacity - firstSparkOpacity - 1.0)
                    .animation(.spring(duration: 1).delay(1), value: secondSparkOpacity)
                
                Image("sparks", bundle: .main)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 20, height: geometry.size.height - 20)
                    .opacity(firstSparkOpacity)
                    .animation(.spring(duration: 1).delay(1).repeatForever(autoreverses: true), value: firstSparkOpacity)
                    .rotationEffect(.degrees(180))
            }
        }
        
    }
    
}

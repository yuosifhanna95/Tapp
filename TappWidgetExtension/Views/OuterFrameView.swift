//
//  OuterFrameView.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 17/03/2025.
//

import SwiftUI

struct OuterFrameView : View {
    
    let circleFrame: CGFloat
    
    var body: some View {
        Image("wheelFrame", bundle: .main)
            .resizable()
            .frame(width: circleFrame, height: circleFrame)
    }
}

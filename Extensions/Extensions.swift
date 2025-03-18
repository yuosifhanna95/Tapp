//
//  Extensions.swift
//  Unity-iPhone
//
//  Created by Adam Shulman on 17/03/2025.
//

import Foundation
import SwiftUICore

extension Date {
    
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
}

extension Color {
    static let colorDarkCard = Color.init(cgColor: CGColor(red: 0 / 255.0, green: 134 / 255.0, blue: 142 / 255.0, alpha: 1))
}

extension Font {
    static let fontBodyRegular: Font = .system(size: 17, weight: .regular, design: .default)
    static let wheelOfCoinsWidgetFontName = "AstounderSquaredBB-Regular"
}


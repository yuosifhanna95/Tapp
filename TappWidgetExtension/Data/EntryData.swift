//
//  EntryData.swift
//  TappWidget
//
//  Created by Adam Shulman on 18/03/2025.
//

import WidgetKit
import SwiftUI

struct SpinEntry: TimelineEntry {
    
    let date: Date
    let state : SpinEntryState
    
}

enum SpinEntryState: Equatable {
    
    case start
    case spinning(model: SpiningWheelStateModel)
    case collect(prizes: [String])
    case unAvailable
    case noNetwork
    
    
    static func ==(lhs: SpinEntryState, rhs: SpinEntryState) -> Bool {
        switch (lhs, rhs) {
        case (.start, .start):
            return true
        case (.spinning, .spinning):
            return true
        
        case let (.collect(leftValue), .collect(rightValue)):
            return leftValue == rightValue
            //MARK: or return leftValue == rightValue
        case (.unAvailable, .unAvailable):
            return true
        default:
            return false
        }
    }
    
}

extension SpinEntryState: RawRepresentable {

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        switch rawValue {
        case "start": self = .start
        case "spinning": self = .spinning(model: SpiningWheelStateModel(rotationAngle: 0.0, firstOpacity: 0.0, secondOpacity: 0.0))
        case "collect": self = .collect(prizes: [])
        case "unAvailable": self = .unAvailable
        case "noNetwork": self = .noNetwork
        default:
            return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .start: return "start"
        case .spinning(model: _): return "spinning"
        case .collect(prizes: _): return "collect"
        case .unAvailable: return "unAvailable"
        case .noNetwork: return "noNetwork"
        }
    }
}

struct SpiningWheelStateModel {
    
    let rotationAngle: CGFloat
    let firstOpacity: CGFloat
    let secondOpacity: CGFloat
    
}

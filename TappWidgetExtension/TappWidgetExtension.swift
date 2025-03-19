//
//  TappWidgetExtension.swift
//  TappWidgetExtension
//
//  Created by Adam Shulman on 17/03/2025.
//

import WidgetKit
import SwiftUI

struct SpinProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> SpinEntry {
        WheelGameManager.shared.setDisplayConfig(size: context.displaySize)
        let entry = SpinEntry(date: Date.now, state: .start(model: SpinningWheelStateModel(rotationAngle: 0, firstOpacity: 1.0, secondOpacity: 0.001)))
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SpinEntry) -> Void) {
        WheelGameManager.shared.setDisplayConfig(size: context.displaySize)
        let entry = SpinEntry(date: Date.now, state: .start(model: SpinningWheelStateModel(rotationAngle: 0, firstOpacity: 1.0, secondOpacity: 0.001)))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SpinEntry>) -> Void) {
        
        //MARK: Check network, if there is, get .start entry.. if no, get .noNetwork entry
        let networkmanager = NetworkManagerNew()
        networkmanager.sendRequestWithService(api: API.checkConnection) { data, error, statusCode in
            if(error != nil) {
                TimeLineManager.shared.timeLineType = .noNetwork(prizes: PrizeManager.shared.prizes)
            } else {
                TimeLineManager.shared.timeLineType = TimeLineManager.shared.previousTimeLineType
            }
        }
        
        WheelGameManager.shared.setDisplayConfig(size: context.displaySize)
        let entries = TimeLineManager.shared.getTimelineSpinEntries(state: TimeLineManager.shared.timeLineType)
        TimeLineManager.shared.entries = entries
        let timeline = Timeline(entries: entries, policy: .atEnd)
        ExtensionManager.shared.setUpSettings()
        PrizeManager.shared.loadPrizeData()
        completion(timeline)
    }
}

struct SpinEntry: TimelineEntry {
    
    let date: Date
    let state : SpinEntryState

}

@available(iOS 17, *)
struct WheelOfCoinsWidget: Widget {
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Constants.WheelOfCoins.keyWOCWidget, provider: SpinProvider()) { entry in
            
            switch entry.state {
            case .start(let model), .spinning(let model):
                WheelView(entry: entry, spinningModel: model)
            //case .spinning(let model):
                //WheelView(entry: entry, spinningModel: model)
                //SpinningWheelView(entry: entry, spinningModel: model)
            case .collect(let model, prizes: _):
                CollectView(entry: entry, spinningModel: model)
            case .unAvailable(let model, prizes: _):
                SpinUnavailableView(entry: entry, spinningModel: model)
            case .noNetwork(let prizes):
                NoNetworkAvailableView(entry: entry, prizes: prizes)
            }
        }
        
        .configurationDisplayName("Wheel of Coins")
        .description("Tap to spin the wheel!")
        .supportedFamilies([.systemSmall])
    }
}

enum SpinEntryState: Equatable {
    
    case start(model: SpinningWheelStateModel)
    case spinning(model: SpinningWheelStateModel)
    case collect(model: SpinningWheelStateModel, prizes: [String])
    case unAvailable(model: SpinningWheelStateModel, prizes: [String])
    case noNetwork(prizes: [String])
    
    static func ==(lhs: SpinEntryState, rhs: SpinEntryState) -> Bool {
        switch (lhs, rhs) {
        case (.start, .start):
            return true
        case (.spinning, .spinning):
            return true
        case let (.collect(leftValue), .collect(rightValue)):
            return true
            //MARK: or return leftValue == rightValue
        case (.unAvailable, .unAvailable):
            return true
        case (.noNetwork, .noNetwork):
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
        case "start": self = .start(model: SpinningWheelStateModel(rotationAngle: 0, firstOpacity: 1.0, secondOpacity: 0.001))
        case "spinning": self = .spinning(model: SpinningWheelStateModel(rotationAngle: 0.0, firstOpacity: 0.0, secondOpacity: 0.0))
        case "collect": self = .collect(model: SpinningWheelStateModel(rotationAngle: 0.0, firstOpacity: 0.0, secondOpacity: 0.0), prizes: [])
        case "unAvailable": self = .unAvailable(model: SpinningWheelStateModel(rotationAngle: 0.0, firstOpacity: 0.0, secondOpacity: 0.0), prizes: [])
        case "noNetwork": self = .noNetwork(prizes: [])
        default:
            return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .start: return "start"
        case .spinning(model: let model): return "spinning"
        case .collect(prizes: let prizes): return "collect"
        case .unAvailable: return "unAvailable"
        case .noNetwork: return "noNetwork"
        }
    }
}

struct SpinningWheelStateModel {
    
    let rotationAngle: Double
    let firstOpacity: CGFloat
    let secondOpacity: CGFloat
    
}

#Preview(as: .systemSmall) {
    WheelOfCoinsWidget()
} timeline: {
    SpinEntry(date: Date.now, state: .collect(model: SpinningWheelStateModel(rotationAngle: 0, firstOpacity: 0.0, secondOpacity: 0.0), prizes: ["g3"]))
}



/*
 //MARK: resume new timeline generation logic;
func getTimeline(in context: Context, completion: @escaping (Timeline<SpinEntry>) -> Void) {
            
    let networkManager = NetworkManagerNew()
    
    networkManager.sendRequestWithService(api: API.checkConnection) { data, error, statusCode in
        
        if let _ = error {
            
            let noNetworkEntry = SpinEntry(date: Date.now, state: .noNetwork)
            let timeline = Timeline(entries: [noNetworkEntry], policy: .atEnd)
            completion(timeline)
            
        } else {
            
            let persistenceManager = PersistenceManager()
                            
            if let startSpin = persistenceManager.load(forKey: "start_spin") ?? false,
               startSpin == true {
                
                
                let currentDate = Date.now
                
                var entries = [SpinEntry]()
                
                let fullRotations = Double(Int.random(in: 3...5)) * 360
                
                let spinEntryStateModel = SpiningWheelStateModel(rotationAngle: Double(WheelGameManager.shared.randomOffset) + Double(fullRotations), firstOpacity: 0.001, secondOpacity: 2.0)
                let spinEntry = SpinEntry(date: currentDate, state: .spinning(model: spinEntryStateModel))
                entries.append(spinEntry)

                let collectPrizeEntryDate = Calendar.current.date(byAdding: .second, value: 5, to: currentDate)!
                let collectPrizeEntry = SpinEntry(date: collectPrizeEntryDate, state: .collect(prizes: PrizeManager.shared.prizes))
                entries.append(collectPrizeEntry)

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                
            } else if let isSpinning = persistenceManager.load(forKey: "is_spinning") ?? false,
                    isSpinning == true {
                
                let startEntry = SpinEntry(date: Date.now, state: .start)
                let timeline = Timeline(entries: [startEntry], policy: .atEnd)
                completion(timeline)
                
            } else {
                
                let startEntry = SpinEntry(date: Date.now, state: .start)
                let timeline = Timeline(entries: [startEntry], policy: .atEnd)
                completion(timeline)
                
            }
           
        }
    }
    
    ExtensionManager.shared.setUpSettings()
    PrizeManager.shared.loadPrizeData()
}
*/

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
//        WheelGameManager.shared.setDisplayConfig(size: context.displaySize)
        let entry = SpinEntry(date: Date.now, state: .start)
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SpinEntry) -> Void) {
//        WheelGameManager.shared.setDisplayConfig(size: context.displaySize)
        let entry = SpinEntry(date: Date.now, state: .start)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SpinEntry>) -> Void) {
        
        //MARK: Check network, if there is, get .start entry.. if no, get .noNetwork entry
        
//        WheelGameManager.shared.setDisplayConfig(size: context.displaySize)
        let entries = TimeLineManager.shared.getTimelineSpinEntries(state: TimeLineManager.shared.timeLineType)
        TimeLineManager.shared.entries = entries
        let timeline = Timeline(entries: entries, policy: .atEnd)
        ExtensionManager.shared.setUpSettings()
        PrizeManager.shared.loadPrizeData()
        completion(timeline)
    }
}

@available(iOS 17, *)
struct WheelOfCoinsWidget: Widget {
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Constants.WheelOfCoins.keyWOCWidget, provider: SpinProvider()) { entry in
            
            switch entry.state {
            case .start:
                WheelView(entry: entry, spinningModel: nil)
            case .spinning(let model):
                SpinningWheelView(entry: entry, spinningModel: model)
            case .collect(prizes: _):
                WheelView(entry: entry, spinningModel: nil)
            case .unAvailable:
                SpinUnavailableView(entry: entry)
            case .noNetwork:
                NoNetworkAvailableView(entry: entry)
            }
        }
        
        .configurationDisplayName("Wheel of Coins")
        .description("Tap to spin the wheel!")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    WheelOfCoinsWidget()
} timeline: {
    SpinEntry(date: Date.now, state: .start)
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

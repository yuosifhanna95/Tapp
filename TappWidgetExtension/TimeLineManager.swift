//
//  TimeLineManager.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 06/03/2025.
//
import Foundation
import WidgetKit

@available(iOS 16, *)
class TimeLineManager {
    
    static let shared = TimeLineManager()
    private let persistenceManager = PersistenceManager()
    
    var timeLineType: SpinEntryState = .start
    var previousTimeLineType: SpinEntryState = .start
    var entries: [SpinEntry] = []
    
    init() { }
    
    func getTimelineSpinEntries(state: SpinEntryState) -> [SpinEntry] {
        
        switch state {
        case .start:
            persistenceManager.save(false, forKey: Constants.WheelOfCoins.keyClaimButtonClicked)
            if(WheelGameManager.shared.spinButtonClicked) {
                TimeLineManager.shared.timeLineType = state
                TimeLineManager.shared.previousTimeLineType = state
                return getRotationSpinEntry()
            }
            return getSpinStartEntries()
        case .collect:
            WheelGameManager.shared.spinButtonClicked = false
            let wocClaimBClicked = persistenceManager.load(forKey: Constants.WheelOfCoins.keyClaimButtonClicked) ?? false
            guard wocClaimBClicked == false else {
                TimeLineManager.shared.timeLineType = .unAvailable
                TimeLineManager.shared.previousTimeLineType = .unAvailable
                return getSpinUnavailablefor8hoursEntries()
            }
            return []
        case .unAvailable:
            let FinalDate = WheelGameManager.shared.lastSpinDate.addingTimeInterval(TimeInterval(Double( Int(WheelGameManager.shared.spinTime)) - 0.5))
            if(FinalDate < Date.now) {
                TimeLineManager.shared.timeLineType = .start
                TimeLineManager.shared.previousTimeLineType = .start
                return getSpinStartEntries()
            }
            return []
            
        case .noNetwork:
            return copyEntriesWithNoNetwork()
//            if(NetworkManager.networkAvailable) {
//                return copyEntriesWithNetwork()
//            } else {
//                return copyEntriesWithNoNetwork()
//            }
        case .spinning(model: let model):
            persistenceManager.save(false, forKey: Constants.WheelOfCoins.keyClaimButtonClicked)
            if(WheelGameManager.shared.spinButtonClicked) {
                TimeLineManager.shared.timeLineType = state
                TimeLineManager.shared.previousTimeLineType = state
                return getRotationSpinEntry()
            }
            return getSpinStartEntries()
        }
    }
    
    func copyEntriesWithNetwork() -> [SpinEntry] {
        var interval:Double = 1
        let wocClaimBClicked = persistenceManager.load(forKey: Constants.WheelOfCoins.keyClaimButtonClicked) ?? false
        switch TimeLineManager.shared.previousTimeLineType {
        case .collect:
//            TimeLineManager.shared.timeLineType = .collect
            let entry = TimeLineManager.shared.entries.last
            return [SpinEntry(date: Date.now.addingTimeInterval(1), state: wocClaimBClicked ? .unAvailable : .collect(prizes: ["PASS SOME PRIZES HERE"]))]
        case .start:
//            TimeLineManager.shared.timeLineType = .start
            WheelGameManager.shared.spinButtonClicked = false
            interval = 1
        case .unAvailable:
//            TimeLineManager.shared.timeLineType = .unAvailable
            interval = 1
            let FinalDate = WheelGameManager.shared.lastSpinDate.addingTimeInterval(TimeInterval(Double( Int(WheelGameManager.shared.spinTime)) - 0.5))
            if FinalDate > Date.now {
                return getSpinUnavailablefor8hoursEntries()
            }
        default:
            interval = 2
        }
        var copiedEntries : [SpinEntry] = []
        if(TimeLineManager.shared.entries.isEmpty) {
            TimeLineManager.shared.timeLineType = .start
            return getSpinStartEntries()
        }
        var ind = 0
        for entry in TimeLineManager.shared.entries {
            let copy = SpinEntry(date: Date.now.addingTimeInterval(interval * Double(ind)), state: entry.state)
//            let copy = SpinEntry(date: Date.now.addingTimeInterval(interval * Double(ind)), rotation: entry.rotation, duration: entry.duration, prizes: entry.prizes, sparkOpacityP1: entry.sparkOpacityP1, sparkOpacityP2: entry.sparkOpacityP2, networkAvailable: true, state: entry.state)
            copiedEntries.append(copy)
            ind += 1
        }
        return copiedEntries
    }
    func copyEntriesWithNoNetwork() -> [SpinEntry] {
        var copiedEntries : [SpinEntry] = []
        switch TimeLineManager.shared.previousTimeLineType {
        case .start:
            return getSpinStartEntries()
        case .collect:
            let wocClaimBClicked = persistenceManager.load(forKey: Constants.WheelOfCoins.keyClaimButtonClicked) ?? false
            if(wocClaimBClicked) {
                return getSpinUnavailablefor8hoursEntries()
            }
            let entry = SpinEntry(date: Date.now, state: .collect(prizes: PrizeManager.shared.prizes))
//            return [SpinEntry(date: Date.now, rotation: Double(WheelGameManager.shared.randomOffset), duration: 0, prizes: WheelGameManager.shared.currentSpinEntry?.prizes ?? PrizeManager.shared.prizes, sparkOpacityP1: 1.0, sparkOpacityP2: 0.001, networkAvailable: NetworkManager.networkAvailable, state: .collect)]
            return [entry]
        case .unAvailable:
            return getSpinUnavailablefor8hoursEntries()
        case .noNetwork:
            print("error previousTimeLineType shouldnt be noNetwork")
        case .spinning(model: let model):
            print("error previousTimeLineType shouldnt be noNetwork")
        }
        if(TimeLineManager.shared.entries.isEmpty) {
            TimeLineManager.shared.timeLineType = .start
            return getSpinStartEntries()
        }
        for entry in TimeLineManager.shared.entries {
            let copy = SpinEntry(date: entry.date, state: entry.state)
//            let copy = SpinEntry(date: entry.date, rotation: entry.rotation, duration: entry.duration, prizes: entry.prizes, sparkOpacityP1: entry.sparkOpacityP1, sparkOpacityP2: entry.sparkOpacityP2, networkAvailable: false, state: entry.state)
            copiedEntries.append(copy)
        }
        return copiedEntries
    }
    func getRotationSpinEntry() -> [SpinEntry] {
        
        // date of the spin
        let currentDate = Date.now
        
        // random rotation between  0 - 360, that is also a multiple of 12
        // ensure at least 3-5 full rotations before slowing down
        let fullRotations = Double(Int.random(in: 3...5)) * 360

        var entries = [SpinEntry]()
        for offset in 0 ..< 2  {
            if(offset == 0) {
                let spinEntryStateModel = SpiningWheelStateModel(rotationAngle: Double(WheelGameManager.shared.randomOffset) + Double(fullRotations), firstOpacity: 0.001, secondOpacity: 2.0)
                let spinEntry = SpinEntry(date: currentDate.addingTimeInterval(TimeInterval(offset*2)), state: .spinning(model: spinEntryStateModel))
                entries.append(spinEntry)
//                entries.append(SpinEntry(date: currentDate.addingTimeInterval(TimeInterval(offset*2)), rotation: Double(WheelGameManager.shared.randomOffset) + Double(fullRotations), duration: 1.5, prizes: WheelGameManager.shared.currentSpinEntry?.prizes ?? PrizeManager.shared.prizes, sparkOpacityP1: 0.001, sparkOpacityP2: 2.0, networkAvailable: NetworkManager.networkAvailable, state: .spinning))
            } else {
                let collectEntry = SpinEntry(date: currentDate.addingTimeInterval(TimeInterval(offset*2)), state: .collect(prizes: PrizeManager.shared.prizes))
                entries.append(collectEntry)
//                entries.append(SpinEntry(date: currentDate.addingTimeInterval(TimeInterval(offset*2)), rotation: Double(WheelGameManager.shared.randomOffset) + Double(fullRotations), duration: 0, prizes: WheelGameManager.shared.currentSpinEntry?.prizes ?? PrizeManager.shared.prizes, sparkOpacityP1: 1.0, sparkOpacityP2: 0.001, networkAvailable: NetworkManager.networkAvailable, state: .collect))
            }
        }
        // update values
        WheelGameManager.shared.currentSpinEntry = entries[0]
        WheelGameManager.shared.completedSpinEntry = entries[1]
        return entries
    }
    
    func getSpinUnavailablefor8hoursEntries() ->[SpinEntry] {
        var entries = [SpinEntry]()
        var FinalDate = WheelGameManager.shared.lastSpinDate.addingTimeInterval(TimeInterval(Double( Int(WheelGameManager.shared.spinTime)) - 0.5))
        if(FinalDate < Date.now) {
            FinalDate = Date.now
            let startEntry = SpinEntry(date: Date.now, state: .start)
//            let EndEntry = SpinEntry(date: Date.now, rotation: 0, duration: 0, prizes: PrizeManager.shared.prizes, sparkOpacityP1: 1.0, sparkOpacityP2: 0.001, networkAvailable: NetworkManager.networkAvailable, state: .start)
            WheelGameManager.shared.currentSpinEntry = startEntry
            return [startEntry]
        }
        let entryDate = Date.now
        for offset in 0 ..< 2  {
            if(offset == 0) {
                let unAvailableEntry = SpinEntry(date: entryDate, state: .unAvailable)
                entries.append(unAvailableEntry)
//                entries.append(SpinEntry(date: entryDate, rotation: 0, duration: 0, prizes: PrizeManager.shared.prizes, sparkOpacityP1: 1.0, sparkOpacityP2: 0.001, networkAvailable: NetworkManager.networkAvailable, state: .unAvailable))
            }
            else {
                let startEntry = SpinEntry(date: entryDate, state: .start)
                entries.append(startEntry)
//                entries.append(SpinEntry(date: FinalDate, rotation: 0, duration: 0, prizes: PrizeManager.shared.prizes, sparkOpacityP1: 1.0, sparkOpacityP2: 0.001, networkAvailable: NetworkManager.networkAvailable, state: .start))
            }
        }
        WheelGameManager.shared.currentSpinEntry = entries[0]
        return entries
    }
    
    func getSpinStartEntries() -> [SpinEntry] {
        let currentDate = Date()
        var entries = [SpinEntry]()
        for offset in 0 ..< 2  {
            let entryDate = Calendar.current.date(byAdding: .second, value: offset * 3, to: currentDate)!
            let startEntry = SpinEntry(date: entryDate, state: .start)
            entries.append(startEntry)
//            entries.append(SpinEntry(date: entryDate, rotation: 0, duration: 0, prizes: PrizeManager.shared.prizes, sparkOpacityP1: 1.0, sparkOpacityP2: 0.001, networkAvailable: NetworkManager.networkAvailable, state: .start))
        }
        WheelGameManager.shared.currentSpinEntry = entries[0]
        return entries
    }

}

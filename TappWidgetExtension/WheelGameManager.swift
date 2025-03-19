//
//  WheelViewManager.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 06/03/2025.
//
import Foundation
import SwiftUI
import WidgetKit

@available(iOS 16, *)
class WheelGameManager {

    //MARK: remove shared, singleton pattern
    
    static let shared = WheelGameManager()
    var spinButtonClicked = false
    let persistenceManager = PersistenceManager()
    
    var currentSpinEntryState: SpinEntryState? {
        set {
            persistenceManager.save(newValue?.rawValue, forKey: Constants.WheelOfCoins.currentSpinEntryStateKey)
        } get {
            if let rawValue: String = persistenceManager.load(forKey: Constants.WheelOfCoins.currentSpinEntryStateKey) {
                return SpinEntryState(rawValue: rawValue)
            }
            return nil
        }
    }
    
    var lastSpinDate : Date {
        didSet {
            persistenceManager.save(lastSpinDate, forKey: Constants.WheelOfCoins.keyLastSpinDate)
        }
    }
    
    var playerID : String {
        didSet {
            persistenceManager.save(playerID, forKey: Constants.WheelOfCoins.keyPlayerID)
        }
    }
    
    var widgetAction : String = "Click" {
        didSet {
            persistenceManager.save(widgetAction, forKey: Constants.WheelOfCoins.keyWidgetAction)
        }
    }
    
    var currentSpinEntry: SpinEntry? // for saving the current spin entry after the rotation is completed
    var completedSpinEntry: SpinEntry? // for saving the current spin entry after the rotation is completed
    var randomOffset:Int = 0
    var width : CGFloat
    var height : CGFloat
    var scaler: CGFloat = 1
    var strDate = Date.now
    let spinTime: Double = 1 * 1 * 20
    let fontName: String = "AstounderSquaredBB-Regular"
    
    public init() {
        
        playerID = persistenceManager.load(forKey: Constants.WheelOfCoins.keyPlayerID) ?? "nil"
        widgetAction = persistenceManager.load(forKey: Constants.WheelOfCoins.keyWidgetAction) ?? "Click"
        lastSpinDate = persistenceManager.load(forKey : Constants.WheelOfCoins.keyLastSpinDate) ?? Date.now.addingTimeInterval(-spinTime)
        persistenceManager.save(false, forKey: Constants.WheelOfCoins.keyClaimButtonClicked)
        
        //MARK: remove view related variables.
        
        width = 170
        height = 170
    }
    
    func getSelectedAction() -> String {
        return self.widgetAction
    }
    
    func getRandomIndex() -> Int {
        randomOffset = Int.random(in: 1...12) * 30
        //calculate prize
//        let numberOfItems = currentSpinEntry?.prizes.count ?? PrizeManager.shared.prizes.count
        let numberOfItems = PrizeManager.shared.prizes.count
        let degreesPerItem = 360.0 / Double(numberOfItems)
        let selectedIndex = (numberOfItems - Int(Double(randomOffset) / degreesPerItem)) % numberOfItems
        return selectedIndex
    }
    
    func perform() {
        
        //MARK: remove network checks
        
//        guard NetworkManager.networkAvailable else {
//            return
//        }
        spinButtonClicked = true
        TimeLineManager.shared.timeLineType = .start(model: SpinningWheelStateModel(rotationAngle: 0, firstOpacity: 1.0, secondOpacity: 0.001))
        TimeLineManager.shared.previousTimeLineType = .start(model: SpinningWheelStateModel(rotationAngle: 0, firstOpacity: 1.0, secondOpacity: 0.001))
        // prepare a boolean value to retrieve possible new prizes
        PrizeManager.shared.didLoadedPrizes = false
        
        //MARK: CHECK ALL THIS LOGIC BELOW

        let selectedIndex = getRandomIndex()
//        let ImageName = currentSpinEntry?.prizes[selectedIndex]
        let ImageName = PrizeManager.shared.prizes[selectedIndex]
        PrizeManager.shared.selectedImagePrize = Image(ImageName, bundle: .main)
       
        PrizeManager.shared.selectedPrizeValue = PrizeManager.shared.prizes[selectedIndex]
//        if((currentSpinEntry?.prizes.count ?? PrizeManager.shared.prizes.count) > selectedIndex) {
//            PrizeManager.shared.selectedPrizeValue = "\(currentSpinEntry?.prizes[selectedIndex] ?? PrizeManager.shared.prizes[selectedIndex])"
//        }
        //NetworkManager.shared.sendPrize()
        let networkmanager = NetworkManagerNew()
        networkmanager.sendRequestWithService(api: API.sendPrize(playerId: WheelGameManager.shared.playerID, prize: PrizeManager.shared.selectedPrizeValue, type: "WOC")) { data, error, statusCode in
            self.updatePlayerID(data: data)
        }
        self.strDate = Date.now

        
        lastSpinDate = Date.now
        // stop spinning the wheel
    }
    
    //MARK: remove view methods
    
    func setDisplayConfig(size: CGSize){
        self.width = size.width
        self.height = size.height
        self.scaler = self.width / 155.0
    }
    
    static func isTimerActive(entry: SpinEntry) -> Bool
    {
        return entry.date.timeIntervalSince1970 - (WheelGameManager.shared.lastSpinDate.timeIntervalSince1970) < WheelGameManager.shared.spinTime - 1
    }
    
    static func isSpinUnavailable(entry: SpinEntry) -> Bool{
        return (WheelGameManager.isTimerActive(entry: entry)) && entry.state == .unAvailable(model: SpinningWheelStateModel(rotationAngle: 0.0, firstOpacity: 0.0, secondOpacity: 0.0), prizes: PrizeManager.shared.prizes)
    }
    
    func updatePlayerID(data: Any?) {
        guard let data = data as? Dictionary<String, AnyObject> else {
            return
        }
        guard let pid = data["playerid"] as? String else {
            return
        }
        if(self.playerID == "nil") {
            self.playerID = pid
        }
    }
}



//
//  ExtensionManager.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 06/03/2025.
//
import Foundation

class ExtensionManager {
    
    static let shared = ExtensionManager()
    let prizeKEY = "WHEELCOINS"
    var urlScheme: String = "animalKingdom"
    var groupName = "group.com.shulman.TappWidget.TappWidgetExtension"//"group.com.innplaylabs.animalkingdom.TAPP"
    
    init() {
        //getter and setter instead
        self.groupName = Bundle.main.object(forInfoDictionaryKey: "AppGroupName") as? String ?? self.groupName
        self.urlScheme = Bundle.main.object(forInfoDictionaryKey: "SchemeURLName") as? String ?? urlScheme
    }
    func setUpSettings() {
        self.groupName = Bundle.main.object(forInfoDictionaryKey: "AppGroupName") as? String ?? self.groupName
        self.urlScheme = Bundle.main.object(forInfoDictionaryKey: "SchemeURLName") as? String ?? self.urlScheme

    }
    func getWidgetURL(entry: SpinEntry, claimView: Bool) -> String{
        return "\(ExtensionManager.shared.urlScheme)://?WidgetType=WOC&Action=\(claimView ? "Collect" : (entry.state == .collect(prizes: []) ? "Collect" : "Click"))&Reward=\(PrizeManager.shared.getSelectedPrizeValue())&playerid=\(WheelGameManager.shared.playerID)&Date=\(WheelGameManager.shared.strDate.formattedString())&Type=\(Constants.WheelOfCoins.keyWOCWidget)&hash=nil"
    }
    
    
}

//
//  SpinIntent.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 03/01/2025.
//


import AppIntents
import WidgetKit
import UIKit

@available(iOS 16, *)
struct SpinIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Spin the Wheel"
    
    func perform() async throws -> some IntentResult {
        
        //MARK: We can check here for network connection, before returning the result() that will refresh the timeline, and then execute some logic depending on the network conditions

        WheelGameManager.shared.perform()
//        TimeLineManager.shared.timeLineType = .spinning(model: SpiningWheelStateModel(rotationAngle: 360.0, firstOpacity: 10.0, secondOpacity: 0.0))
//        
//        let pers = PersistenceManager()
//        
//        pers.save(true, forKey: "start_spin")
//        let networkmanager = NetworkManagerNew()
//        let result = await networkmanager.sendRequestWithService(api: API.sendPrize(playerId: WheelGameManager.shared.playerID, prize: PrizeManager.shared.selectedPrizeValue, type: "WOC"))
//        
        return .result()
    }
}

@available(iOS 16, *)
struct RefreshNetworkWOCIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Refresh the Network"
    
    func perform() async throws -> some IntentResult {
        //getting new timeline when performing
//        NetworkManager.shared.rnWOC()
        //
        return .result()
    }
}

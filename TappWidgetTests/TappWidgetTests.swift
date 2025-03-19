//
//  TappWidgetTests.swift
//  TappWidgetTests
//
//  Created by Adam Shulman on 17/03/2025.
//

import Testing
@testable import TappWidget

struct TappWidgetTests {
    
    @Test func testWheelPrizeDataAPI() async throws {
        
        let networkManager = NetworkManagerNew()
        
        let result = await networkManager.sendRequestWithService(api: API.getWheelPrizeData)
        
        #expect(result.data != nil)
    }
    
    @Test func testWheelSendPrizeAPI() async throws {
        
        let networkManager = NetworkManagerNew()
        
        let result = await networkManager.sendRequestWithService(api: API.sendPrize(playerId: "1", prize: "prize", type: "wheel"))
        
        #expect(result.data != nil)
    }
    
    @Test func testPersistanceGetCachedPrizes() async throws {
        
        let persistenceManager = PersistenceManager()
                
        let dictionary: Dictionary<String,AnyObject>? = persistenceManager.load(forKey: Constants.WheelOfCoins.keyCachedPrizesWheel)
        
        #expect(dictionary != nil)
    }

}
        
        

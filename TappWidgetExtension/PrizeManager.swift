//
//  PrizeManager.swift
//  Unity-iPhone
//
//  Created by Yuosif Hanna on 10/03/2025.
//
import Foundation
import SwiftUI
import WidgetKit

class PrizeManager {
    
    static let shared = PrizeManager()
    private let persistenceManager = PersistenceManager()
    
    //var circleIcons: [Image] = [.init("c1", bundle: .main), .init("e1", bundle: .main), .init("g1", bundle: .main), .init("gift", bundle: .main), .init("c2", bundle: .main), .init("e2", bundle: .main), .init("g2", bundle: .main), .init("gift", bundle: .main), .init("c3", bundle: .main), .init("e3", bundle: .main), .init("g3", bundle: .main), .init("gift", bundle: .main) ]
    
    var prizes: [String] = ["c1", "e1", "g1", "gift", "c2", "e2", "g2", "gift", "c3", "e3", "g3", "gift"]
    
    var cachedPrizesWheel : Dictionary<String,AnyObject>? {
        didSet {
            persistenceManager.save(cachedPrizesWheel, forKey: Constants.WheelOfCoins.keyCachedPrizesWheel)
        }
    }
    
    var didLoadedPrizes : Bool = false {
        didSet {
            persistenceManager.save(didLoadedPrizes, forKey: Constants.WheelOfCoins.keyDidLoadedPrizes)
        }
    }
    
    var selectedImagePrize: Image? = nil
    var selectedPrizeValue: String = ""
    
    init() {
        self.cachedPrizesWheel = persistenceManager.load(forKey : Constants.WheelOfCoins.keyCachedPrizesWheel) ?? nil
        fillPrizesFromCached()
    }
    
    func getSelectedPrizeValue() -> String {
        return selectedPrizeValue
    }
    
    func fillPrizesFromCached() {
        guard let cache = cachedPrizesWheel else {
            return
        }
        if let prizes = cache["prizes"] as? [String] {
            self.fillprizes(prizes: prizes)
        }
    }
    
    func fillprizes(prizes: [String]) {
        //var arr : [Image] = []
        self.prizes = []
        for prize in prizes {
            //arr.append(Image(prize, bundle: .main))
            self.prizes.append(prize)
        }
       //return arr
    }
    
    func loadPrizeData() {
        let networkManager = NetworkManagerNew()
        networkManager.sendRequestWithService(api: API.mock) { data, error, statusCode in
            guard let data = data as? Dictionary<String, AnyObject> else {
                return
            }
            guard let prizes = data["prizes"] as? [String] else {
                return
            }
            
            //MARK: CHECK this function, why there is a state check? load prize data just need to Load Prize Data, thats it. 
//            if(!(WheelGameManager.shared.currentSpinEntry?.state ?? .spinning == .spinning)) {
//                if(!self.didLoadedPrizes) {
//                    self.circleIcons = self.fillprizes(prizes: prizes)
//                    self.didLoadedPrizes = true
//                    WidgetCenter.shared.reloadTimelines(ofKind: Constants.WheelOfCoins.keyWOCWidget)
//                }
//            }
            
            if(!self.didLoadedPrizes) {
                self.fillprizes(prizes: prizes)
                self.didLoadedPrizes = true
                WidgetCenter.shared.reloadTimelines(ofKind: Constants.WheelOfCoins.keyWOCWidget)
            }
            self.cachedPrizesWheel = data
        }
    }
}

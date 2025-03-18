//
//  RequestParser.swift
//  Unity-Iphone
//
//  Created by Adam Shulman on 12/3/2025.
//

import Foundation

class RequestParser: NSObject {
    
    class func parseRequest(responseData: Data, api: API) -> Any? {
        switch api {
        case .getWheelPrizeData, .getScratchPrizeData:
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let jsonObject = jsonData as? [AnyHashable : Any] {
                    return jsonObject
                }
                return nil
            } catch { return nil }
        case .sendPrize:
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let jsonObject = jsonData as? [AnyHashable : Any] {
                    return jsonObject
                }
                return jsonData
            } catch { return nil }
        case .mock:
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let jsonObject = jsonData as? [AnyHashable : Any] {
                    return jsonObject
                }
                return nil
            } catch { return nil }
        case .checkConnection:
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let jsonObject = jsonData as? [AnyHashable : Any] {
                    return jsonObject
                }
                return nil
            } catch { return nil }
        }
    }
}

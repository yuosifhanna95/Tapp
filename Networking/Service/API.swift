//
//  API.swift
//  Unity-Iphone
//
//  Created by Adam Shulman on 12/3/2025.
//

import Foundation

public enum API {
    case getWheelPrizeData
    case getScratchPrizeData
    case sendPrize(playerId: String, prize: String, type: String)
    case mock
    case checkConnection
}

extension API: EndPointType {
        
    var environmentBaseURL: String {
        switch NetworkManagerNew.environment {
        case .debug:
            return "https://picowidgets.s3.us-west-1.amazonaws.com"
        case .staging:
            return "https://picowidgets.s3.us-west-1.amazonaws.com"
        case .production:
            return "https://picowidgets.s3.us-west-1.amazonaws.com"
        }
    }
    
    var baseUrl: URL? {
        switch self {
        case .sendPrize:
            return URL(string: "https://apigateway-eu-zyz85v7.ew.gateway.dev/v1")
        case .mock:
            return URL(string: "https://delightful-scythe-shell.glitch.me/getRandomPrizes")
        case .checkConnection:
            return URL(string: "https://www.google.com")
        default:
            return URL(string: environmentBaseURL)
        }
    }
    
    var httpMethod: HTTPNetworkMethod {
        switch self {
        case  .sendPrize:
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    var path: String {
        switch self {
        case .getWheelPrizeData:
            return "/picowheelconf.json"
        case .getScratchPrizeData:
            return "/picosccratchconf.json"
        case .sendPrize:
            return "/setPrize"
        case .mock:
            return ""
        case .checkConnection:
            return ""
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getWheelPrizeData, .getScratchPrizeData:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .none, urlParameters: nil)
        case .sendPrize(playerId: let playerId, prize: let prize, type: let type):
            return .requestParametersAndHeaders(bodyParameters: ["type" : type], bodyEncoding: .urlAndJsonEncoding, urlParameters: ["playerid": playerId, "prize": prize, "key" : "AIzaSyAQBiMmoehvdaze1YKnQSwFIVDdOSgAXzk"], additionHeaders: headers)
        case .mock:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .none, urlParameters: nil)
        case .checkConnection:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .none, urlParameters: nil)
        }
    }
}

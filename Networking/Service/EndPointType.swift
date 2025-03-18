//
//  EndPointType.swift
//  Unity-Iphone
//
//  Created by Adam Shulman on 12/3/2025.
//

import Foundation

protocol EndPointType {
    
    var baseUrl : URL? { get }
    var path : String { get }
    var httpMethod : HTTPNetworkMethod { get }
    var task : HTTPTask { get }
    var headers : HTTPHeaders? { get }
    
}

//
//  NetworkManager.swift
//  Unity-Iphone
//
//  Created by Adam Shulman on 12/3/2025.
//


import Foundation

enum NetworkEnvironment {
    case debug
    case staging
    case production
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case notEnoughCredits = "You don't have enough credits left in your account."
    case maintaince = "The server under maintaince."
}

enum NetworkResult<String>{
    case success
    case failure(String)
}

struct NetworkManagerNew {
        
    #if DEBUG
    static let environment : NetworkEnvironment = .debug
    #elseif ADHOC
    static let environment : NetworkEnvironment = .staging
    #else
    static let environment : NetworkEnvironment = .production
    #endif
    
    let router = Router<API>()
    
    //MARK: with closure
    
    func sendRequestWithService(api: API, completion: ((_ data: Any?, _ error: String?, _ statusCode: Int) -> ())? = nil) {
        router.request(api) { (data, response, error) in
            if error != nil {
                var errorFullDescription: String!
                if let failingUrl = (error as? NSError)?.userInfo["NSErrorFailingURLStringKey"] as? String {
                    errorFullDescription = (error?.localizedDescription ?? "") + " " + "\n" + failingUrl
                } else {
                    errorFullDescription = error?.localizedDescription ?? ""
                }
                completion?(nil, errorFullDescription, 500)
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion?(nil, NetworkResponse.noData.rawValue, response.statusCode)
                        return
                    }
                    let apiResponse = RequestParser.parseRequest(responseData: responseData, api: api)
                    if (apiResponse != nil){
                        completion?(apiResponse, nil, response.statusCode)
                    }else{
                        completion?(nil, error?.localizedDescription, response.statusCode)
                    }
                case .failure(let networkFailureError):
                    
                    guard let responseData = data else {
                        completion?(nil, networkFailureError, response.statusCode)
                        return
                    }
                    let apiResponse = RequestParser.parseRequest(responseData: responseData, api: api)
                    if (apiResponse != nil){
                        completion?(apiResponse, networkFailureError, response.statusCode)
                    }else{
                        completion?(nil, networkFailureError, response.statusCode)
                    }
                }
            } else {
                completion?(nil, NetworkResponse.failed.rawValue, 500)
            }
        }
    }
    
    //MARK: with async
    
    func sendRequestWithService(api: API) async -> (data: Any?, error: String?, statusCode: Int) {
        return await withCheckedContinuation { continuation in
            
            router.request(api) { (data, response, error) in
                
                // Handle network error
                if let error = error {
                    var errorFullDescription: String!
                    
                    if let failingUrl = (error as NSError).userInfo["NSErrorFailingURLStringKey"] as? String {
                        errorFullDescription = error.localizedDescription + "\n" + failingUrl
                    } else {
                        errorFullDescription = error.localizedDescription
                    }
                    
                    continuation.resume(returning: (nil, errorFullDescription, 500))
                    return
                }
                
                // Validate HTTP response
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(returning: (nil, NetworkResponse.failed.rawValue, 500))
                    return
                }
                
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        continuation.resume(returning: (nil, NetworkResponse.noData.rawValue, response.statusCode))
                        return
                    }
                    
                    let apiResponse = RequestParser.parseRequest(responseData: responseData, api: api)
                    
                    if let apiResponse = apiResponse {
                        continuation.resume(returning: (apiResponse, nil, response.statusCode))
                    } else {
                        continuation.resume(returning: (nil, error?.localizedDescription, response.statusCode))
                    }
                    
                case .failure(let networkFailureError):
                    guard let responseData = data else {
                        continuation.resume(returning: (nil, networkFailureError, response.statusCode))
                        return
                    }
                    
                    let apiResponse = RequestParser.parseRequest(responseData: responseData, api: api)
                    
                    if let apiResponse = apiResponse {
                        continuation.resume(returning: (apiResponse, networkFailureError, response.statusCode))
                    } else {
                        continuation.resume(returning: (nil, networkFailureError, response.statusCode))
                    }
                }
            }
        }
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case       402: return .failure(NetworkResponse.notEnoughCredits.rawValue)
        case       500: return .failure(NetworkResponse.maintaince.rawValue)
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case       503: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
}

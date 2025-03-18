//
//  NetworkRouter.swift
//  Unity-Iphone
//
//  Created by Adam Shulman on 12/3/2025.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter : AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func uploadDataRequest(_ route: EndPoint, api : API, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    private let session = URLSession(configuration: .default)
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
#if DEBUG
                NetworkLogger.log(response: response, data: data, error: error)
#endif
            })
#if DEBUG
            NetworkLogger.log(request: request)
#endif
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    func uploadDataRequest(_ route: EndPoint, api : API, completion: @escaping NetworkRouterCompletion) {
        
        do {
            var request = try self.buildRequest(from: route)
            
            let boundary = UUID().uuidString
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = data
            request.timeoutInterval = 30.0
            
            NetworkLogger.log(request: request)
            task = session.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
            
        }catch {
            
            completion(nil, nil, error)
        }
        
        self.task?.resume()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        guard route.baseUrl != nil else {throw NSError(domain: "", code: 1000, userInfo: [:])}
        
        //let urlPath = route.baseUrl
        var request = URLRequest(url: (route.baseUrl?.appendingPathComponent(route.path))!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 20.0)
        
        request.httpMethod = route.httpMethod.rawValue
        request.timeoutInterval = 90.0
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding ,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding ,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

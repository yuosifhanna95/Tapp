//
//  NetworkLogger.swift
//  Unity-Iphone
//
//  Created by Adam Shulman on 12/3/2025.
//

import Foundation

class NetworkLogger {
    
    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        print(logOutput)
    }
    
    static func log(response: URLResponse?, data: Data?, error: Error?) {
        
        print("\n - - - - - - - - - -  Incoming  - - - - - - - - - - \n")
        
        if let urlResponse = response { print(urlResponse.url?.absoluteString ?? "") }
        
        if let responseData = data { print(responseData.prettyPrintedJSONString ?? "") }
        
        if let requestError = error { print(requestError.localizedDescription) }
        
        print("\n - - - - - - - - - -  END  - - - - - - - - - - \n")
        
    }
}

extension Data {
    
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

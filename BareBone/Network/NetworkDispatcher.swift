//
//  NetworkDispatcher.swift
//  NetworkLayer
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

public enum NetworkErrors: Error {
    case badInput
    case noData
    case badRequest(String)
    case unauthorized(String)
    case forbidden(String)
    case notFound(String)
    case manyRequests(String)
    case internalServerError(String)
    case unknown(String)
}

public class NetworkDispatcher: Dispatcher {
    private var environment: Environment
    private var session: URLSession
    private var requestCount = 0
    
    public required init(environment: Environment) {
        self.environment = environment
        self.session = URLSession(configuration: .default)
    }
    
    public func execute(_ request: Request, completion: @escaping (Response) -> Void) throws {
        let urlRequest = try prepareURLRequest(for: request)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        requestCount += 1
        session.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            self.requestCount -= 1
            if self.requestCount == 0 {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            completion(Response((urlResponse as? HTTPURLResponse, data, error), for: request))
        }).resume()
    }
    
    // MARK: - Private
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        let urlString = "\(environment.host)/\(request.path)"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        
        switch request.parameters {
        case .body(let params):
            switch params {
            case let dict as [String:Any]:
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0))
            case let array as [[String:Any]]:
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: array, options: .init(rawValue: 0))
            default:
//                throw NetworkErrors.badInput
                break
            }
            
        case .url(let params):
            if let params = params as? [String : String] {
                let queryParams = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                
                guard var components = URLComponents(string: urlString) else {
                    throw NetworkErrors.badInput
                }
                
                components.queryItems = queryParams
                urlRequest.url = components.url
            }
            else {
                throw NetworkErrors.badInput
            }
        }
        
        environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}

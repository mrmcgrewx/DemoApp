//
//  Response.swift
//  NetworkLayer
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public enum Response {
    case data(_ : Data)
    case error(_:Int?, _: Error)
    
    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        guard response.r?.statusCode == 200, response.error == nil else {
            var message: String?
            if let msgData = response.data {
                message = String(data: msgData, encoding: .utf8)
            }
            var error: Error
            let code = response.r?.statusCode ?? 0
            let data: Data = response.data ?? Data()
            switch code {
            case 400:
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                    var messages = ""
                    json?.forEach { item in
                        if let msg = item["message"] as? String {
                            messages += "\(msg)\n"
                        }
                    }
                    if messages.count == 0 {
                        messages = "An error has occurred while executing your request."
                    }
                    error = NetworkErrors.badRequest(messages)
                }
                else {
                    error = NetworkErrors.badRequest(message ?? "An error has occurred while executing your request.")
                }
            case 401:
                error = NetworkErrors.unauthorized(message ?? "Invalid or no authentication provided.")
            case 403:
                error = NetworkErrors.forbidden(message ?? "The authenticated user does not have access to the requested resource.")
            case 404:
                error = NetworkErrors.notFound(message ?? "The requested resource could not be found.")
            case 429:
                error = NetworkErrors.manyRequests(message ?? "The limit of API calls allowed has been exceeded.")
            case 500:
                error = NetworkErrors.internalServerError(message ?? "An error has occurred while executing your request.")
            default:
                if response.error != nil {
                    error = NetworkErrors.unknown(response.error!.localizedDescription)
                }
                else {
                    error = NetworkErrors.noData
                }
            }
            
            self = .error(response.r?.statusCode, error)
            return
        }
        
        guard let data = response.data else {
            self = .error(response.r?.statusCode, NetworkErrors.noData)
            return
        }
        
        self = .data(data)
    }
}

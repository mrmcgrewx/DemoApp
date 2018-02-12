//
//  Environment.swift
//  NetworkLayer
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public struct Environment {
    public var name: String
    public var host: String
    public var headers: [String : Any] = ["Content-Type" : "application/json"]
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    public init(_ name: String, host: String) {
        self.name = name
        self.host = host
    }
}

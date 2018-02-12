//
//  Request.swift
//  NetworkLayer
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

public enum HttpMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}

public enum RequestParams {
    case body(_ : Any?)
    case url(_ : [String : Any]?)
}

public protocol Request {
    var path: String { get }
    var method: HttpMethod { get }
    var parameters: RequestParams { get }
    var headers: [String : Any]? { get }
}

extension Request {
    public var method: HttpMethod { return .get }
    public var headers: [String : Any]? {  return nil }
}

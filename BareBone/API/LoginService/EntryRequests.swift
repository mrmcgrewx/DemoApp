//
//  EntryRequests.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public enum EntryRequests: Request {
    case login(username: String, password: String)
    
    public var method: HttpMethod { return .post }
    
    public var path: String {
        switch self {
        case .login(_, _):
            return "client/login"
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .login(let username, let password):
            return .body(["username" : username, "password" : password])
        }
    }
}

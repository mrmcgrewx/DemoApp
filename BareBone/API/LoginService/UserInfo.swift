//
//  UserInfo.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public struct UserInfo: Serialization {
    let id: String
    let username: String
    let firstName: String
    let lastName: String
    let token: String
    
    init(_ json: [String:Any]) throws {
        self.id = try UserInfo.value("_id", from: json)
        self.username = try UserInfo.value("username", from: json)
        self.firstName = try UserInfo.value("firstName", from: json)
        self.lastName = try UserInfo.value("lastName", from: json)
        self.token = try UserInfo.value("token", from: json)
    }
    
}

//
//  Serialization.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
}

protocol Serialization {
}

extension Serialization {
    static func value<T>(_ name: String, from json: [String : Any]) throws -> T {
        guard let obj = json[name] as? T else {
            throw SerializationError.missing(name)
        }
        return obj
    }
}

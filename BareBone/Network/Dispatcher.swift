//
//  Dispatcher.swift
//  NetworkLayer
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public protocol Dispatcher {
    init(environment: Environment)
    func execute( _ request: Request, completion: @escaping (Response) -> Void) throws
}

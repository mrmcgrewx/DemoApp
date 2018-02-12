//
//  Operation.swift
//  NetworkLayer
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public enum Result<T> {
    case data(_ : T)
    case error(_ : Error)
}

protocol Operation {
    associatedtype Output
    
    var request: Request { get }
    
    func execute(in dispatcher: Dispatcher, completion: @escaping (Result<Output>) -> Void)
}

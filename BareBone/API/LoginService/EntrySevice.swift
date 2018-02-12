//
//  EntrySevice.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

final class EntryService {
    private var dispatcher: NetworkDispatcher
    
    init(with dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func login(username: String, password: String, completion: @escaping (Result<UserInfo>) -> Void) {
        let operation = LoginOperation(username: username, password: password)
        operation.execute(in: dispatcher) { result in DispatchQueue.main.async { completion(result) } }
    }
}

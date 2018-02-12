//
//  LoginOperation.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

class LoginOperation: Operation {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    var request: Request {
        return EntryRequests.login(username: self.username, password: self.password)
    }
    
    func execute(in dispatcher: Dispatcher, completion: @escaping (Result<UserInfo>) -> Void) {
        do {
            try dispatcher.execute(request) { response in
                switch response {
                case .data(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                        let userInfo = try UserInfo(json)
                        completion(Result.data(userInfo))
                    }
                    catch { completion(Result.error(error))}
                case .error(_, let error):
                    completion(Result.error(error))
                }
            }
        }
        catch {
            completion(Result.error(error))
        }
    }
}

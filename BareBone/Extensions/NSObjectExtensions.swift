//
//  NSObjectExtensions.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

extension NSObject
{
    class var nameOfClass: String
    {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

//
//  Presentable.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

protocol Presentable
{
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable
{
    func toPresent() -> UIViewController?
    {
        return self
    }
}

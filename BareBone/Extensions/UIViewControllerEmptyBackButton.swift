//
//  UIViewControllerEmptyBackButton.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

public let swizzling: (UIViewController.Type) -> () = { viewController in
    let originalSelector = #selector(viewController.viewDidLoad)
    let swizzledSelector = #selector(viewController.custom_viewDidLoad)
    
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

extension UIViewController {
    @objc func custom_viewDidLoad() {
        self.custom_viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

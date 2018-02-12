//
//  HomeController.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class HomeController: UIViewController, HomeView {
    var onHomeComplete: (() -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            onHomeComplete?()
        }
    }
}

//
//  LoginController.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class LoginController: UIViewController, LoginView {

    var onLoginComplete: ((UserInfo) -> Void)?
    var goToHome: (() -> Void)?
    
    @IBOutlet weak var username: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    
    var entryService: EntryService?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("works")
        self.view.addBackground()
        self.hideBar()
    }

    //MARK: - Action Functions
    @IBAction func loginAction(_ sender: FancyButton) {
        let user = username.text
        let pass = password.text
        if (user == nil || user == "") {
            return
        }
        if (pass == nil || pass == "") {
            return
        }
        
        goToHome?()
        
        /*
        entryService?.login(username: user!, password: pass!, completion: { result in
            switch result {
            case .data:
                Validate your data here
                onLoginComplete?()
            case .error:
                Let them know its wrong
            }
            
        })*/
    }
    
}

//
//  EntryCoordinator.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

class EntryCoordinator: Coordinator, EntryCoordinatorOutput {
    
    
    
    var childCoordinators: [Coordinator] = []
    var homeFlow: ((UserInfo) -> Void)?
    var goToHome: (() -> Void)?
    
    private let factory: EntryModuleFactory
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, factory: EntryModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    func start() {
        showLogin()
    }
    
    // MARK: - Private
    private func showLogin() {
        let loginScreenOutput = factory.makeLoginScreenOutput()
        loginScreenOutput.onLoginComplete = { [weak self] userInfo in
            self?.homeFlow?(userInfo)
        }
        loginScreenOutput.goToHome = {[weak self] in
            self?.goToHome?()
        }
        router.setRootModule(loginScreenOutput)
    }
}

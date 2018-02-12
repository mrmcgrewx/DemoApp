//
//  HomeCoordinator.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator, HomeCoordinatorOutput {
    var childCoordinators: [Coordinator] = []
    var finishFlow: (() -> Void)?
    
    var userInfo: UserInfo?
    
    private let factory: HomeModuleFactory
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, factory: HomeModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    func start() {
        showHome()
    }
    
    // MARK: - Private
    private func showHome() {
        let homeScreenOutput = factory.makeHomeScreenOutput()
        homeScreenOutput.onHomeComplete = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(homeScreenOutput, hideBar: false, animated: true)
    }
    

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        router.present(alert)
    }
}

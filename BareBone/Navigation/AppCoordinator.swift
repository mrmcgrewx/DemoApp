//
//  AppCoordinator.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    func start() {
        runLoginFlow()
    }
    
    func runLoginFlow() {
        let coordinator = coordinatorFactory.makeEntryCoordinator(router: router)
        coordinator.homeFlow = { [weak self] userInfo in
            self?.runHomeFlow(with: userInfo)
        }
        coordinator.goToHome = { [weak self] in
            self?.runHomeFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    func runHomeFlow(with userInfo: UserInfo) {
        let coordinator = coordinatorFactory.makeHomeCoordinator(router: router) as! HomeCoordinator
        coordinator.userInfo = userInfo
        coordinator.finishFlow = { [weak self] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    func runHomeFlow() {
        let coordinator = coordinatorFactory.makeHomeCoordinator(router: router) as! HomeCoordinator
        coordinator.finishFlow = { [weak self] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
}

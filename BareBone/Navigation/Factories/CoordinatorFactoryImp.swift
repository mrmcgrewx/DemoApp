//
//  CoordinatorFactoryImp.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

/// Creates the navigation coordinators for each part of the app
final class CoordinatorFactoryImp: CoordinatorFactory
{
    var networkDispatcher: NetworkDispatcher?
    
    func makeHomeCoordinator(router: Router) -> Coordinator & HomeCoordinatorOutput {
        let factory = ModuleFactoryImp()
        factory.networkDispatcher = networkDispatcher
        return HomeCoordinator(router: router, factory: factory, coordinatorFactory: self)
    }
    
    func makeEntryCoordinator(router: Router) -> Coordinator & EntryCoordinatorOutput {
        let factory = ModuleFactoryImp()
        factory.networkDispatcher = networkDispatcher
        return EntryCoordinator(router: router, factory: factory, coordinatorFactory: self)
    }
}

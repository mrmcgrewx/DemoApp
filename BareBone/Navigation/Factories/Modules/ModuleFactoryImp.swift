//
//  ModuleFactoryImp.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

final class ModuleFactoryImp: HomeModuleFactory, EntryModuleFactory {
    
    var networkDispatcher: NetworkDispatcher?
    
    func makeHomeScreenOutput() -> HomeView {
        let controller = HomeController.controllerFromStoryboard(.home)
        return controller
    }
    
    func makeLoginScreenOutput() -> LoginView {
        let controller = LoginController.controllerFromStoryboard(.login)
        controller.entryService = EntryService(with: networkDispatcher!)
        return controller
    }
}

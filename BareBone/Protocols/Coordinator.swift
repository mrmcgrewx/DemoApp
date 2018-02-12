//
//  Coordinator.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

protocol Coordinator: class
{
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator
{
    func addDependency(_ coordinator: Coordinator)
    {
        if childCoordinators.contains(where: {$0 === coordinator} ) {
            return
        }
        
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?)
    {
        if childCoordinators.isEmpty {
            return
        }
        
        guard let index = childCoordinators.index(where: {$0 === coordinator} ) else { return }
        childCoordinators.remove(at: index)
    }
}

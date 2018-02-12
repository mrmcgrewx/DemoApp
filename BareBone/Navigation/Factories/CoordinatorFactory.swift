//
//  CoordinatorFactory.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

protocol CoordinatorFactory
{
    var networkDispatcher: NetworkDispatcher? { get set }
    
    func makeHomeCoordinator(router: Router) -> Coordinator & HomeCoordinatorOutput
    func makeEntryCoordinator(router: Router) -> Coordinator & EntryCoordinatorOutput
}

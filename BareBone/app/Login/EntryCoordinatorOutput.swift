//
//  EntryCoordinatorOutput.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

protocol EntryCoordinatorOutput: class {
    var homeFlow: ((UserInfo) -> Void)? { get set }
    var goToHome: (() -> Void)? { get set }
}

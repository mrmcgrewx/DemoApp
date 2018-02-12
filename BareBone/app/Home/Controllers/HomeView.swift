//
//  HomeView.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

protocol HomeView: NSObjectProtocol, Presentable {
    var onHomeComplete: (() -> Void)? { get set }
}

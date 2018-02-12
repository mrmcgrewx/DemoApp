//
//  RouterImp.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

final class RouterImp: Router {
    private weak var rootViewController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(rootViewController: UINavigationController)
    {
        self.rootViewController = rootViewController
        completions = [:]
    }
    
    func toPresent() -> UIViewController?
    {
        return rootViewController
    }
    
    // MARK: set root
    func setRootModule(_ module: Presentable?)
    {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    {
        setRootModule(module, hideBar: hideBar, animated: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool)
    {
        guard let controller = module?.toPresent() else { return }
        rootViewController?.setViewControllers([controller], animated: animated)
        rootViewController?.isNavigationBarHidden = hideBar
    }
    
    // MARK: present
    func present(_ module: Presentable?)
    {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool)
    {
        guard let controller = module?.toPresent() else { return }
        rootViewController?.present(controller, animated: animated, completion: nil)
    }
    
    // MARK: dismiss
    func dismissModule()
    {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    {
        rootViewController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: push
    func push(_ module: Presentable?)
    {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, animated: Bool)
    {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    {
        guard let controller = module?.toPresent(), (controller is UINavigationController == false) else {
            assertionFailure("Deprecated push")
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        rootViewController?.pushViewController(controller, animated: animated)
    }
    
    // MARK: pop
    func popModule()
    {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)
    {
        if let controller = rootViewController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func popToRootModule(animated: Bool)
    {
        if let controllers = rootViewController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    // MARK: private
    private func runCompletion(for controller: UIViewController)
    {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

//
//  AppDelegate.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var appCoordinator: Coordinator = self.makeCoordinator()
    private lazy var networkDispatcher: NetworkDispatcher = self.makeNetworkDispatcher()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        swizzling(UIViewController.self)
        appCoordinator.start()
        return true
    }
    
    private func makeCoordinator() -> Coordinator
    {
        let factory = CoordinatorFactoryImp()
        factory.networkDispatcher = networkDispatcher
        
        return AppCoordinator(router: RouterImp(rootViewController: self.window?.rootViewController as! UINavigationController), coordinatorFactory: factory)
    }
    
    private func makeNetworkDispatcher() -> NetworkDispatcher {
        let environment = Environment("prod", host: "http://localhost.com" )
        return NetworkDispatcher(environment: environment)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "BareBone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


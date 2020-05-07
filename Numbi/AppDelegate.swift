//
//  AppDelegate.swift
//  Numbi
//
//  Created by Vadym on 23.04.2020.
//  Copyright © 2020 Vadym Slobodianiuk. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = NewNoteViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising Realm, \(error)")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        return true
    }
}


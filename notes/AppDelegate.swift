//
//  AppDelegate.swift
//  notes
//
//  Created by Douglas Gelsleichter on 05/11/19.
//  Copyright © 2019 Douglas Gelsleichter. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var token: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = LoginViewController()
        let nav = UINavigationController.init(rootViewController: vc)
       
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}


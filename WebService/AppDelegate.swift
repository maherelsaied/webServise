//
//  AppDelegate.swift
//  WebService
//
//  Created by Maher on 10/2/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if helper.getApiToken() != nil {
            let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
            window?.rootViewController = tab
            
        }
        
        return true
    }

   
}


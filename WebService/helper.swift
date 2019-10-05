//
//  helper.swift
//  WebService
//
//  Created by Maher on 10/3/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit

class helper: NSObject {
    class func restartApp(){
        guard let window = UIApplication.shared.keyWindow else{return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc = UIViewController()
        if getApiToken() == nil {
            //go to login screen
            vc = sb.instantiateInitialViewController()!
        } else{
            //go to main screen
            vc = sb.instantiateViewController(withIdentifier: "main")
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
    
        
    }
    class func saveApiToken(token:String){
        let def = UserDefaults.standard
        def.setValue(token, forKey: "api_token")
        def.synchronize()
        restartApp()
    }
    
    class func getApiToken ()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "api_token") as? String
    }
}

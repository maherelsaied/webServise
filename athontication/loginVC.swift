//
//  ViewController.swift
//  WebService
//
//  Created by Maher on 10/2/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class loginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginaction(_ sender: UIButton) {
        guard let email = emailTF.text , !email.isEmpty else{return}
        guard let password = passwordTF.text , !password.isEmpty else{return}
        
        API.login(email: email, password: password) { (error:Error?, success:Bool) in
            if success {
                //every thing is ok
            }else
            {
                //have Error
            }
            
            
            
            
        }
    }
}


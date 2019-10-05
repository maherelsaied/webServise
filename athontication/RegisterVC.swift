//
//  RegisterVC.swift
//  WebService
//
//  Created by Maher on 10/2/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmePassTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard let name = nameTF.text?.trimed, !name.isEmpty , let email = emailTF.text?.trimed, !email.isEmpty , let password = passwordTF.text ,!password.isEmpty , let confirmPasswoed = confirmePassTF.text , !confirmPasswoed.isEmpty else {
            return
        }
        guard password == confirmPasswoed else{return}
        
        API.Register(name: name, email: email, password: password) { (error:Error?, success:Bool) in
            if success {
                print("welcome")
            }
        }
    }
    
    
}

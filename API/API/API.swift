//
//  API.swift
//  WebService
//
//  Created by Maher on 10/2/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class API: NSObject {
    
    class func login(email:String , password:String , completion:@escaping (_ Erorr:Error? ,
        _ success:Bool)->Void) {
        
        let url = "http://elzohrytech.com/alamofire_demo/api/v1/login"
        let parameters = ["email":email , "password":password]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result
                {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    if (json["status"].int == 0){
                        print("invalid email")
                    }
                    else{
                        if let api_token = json["user"]["api_token"].string {
                            helper.saveApiToken(token: api_token)
                            completion(nil,true)
                            print(api_token)
                        }
                    }
                }
        }
        
    }
    
    class func Register (name:String , email : String ,password:String ,completion:@escaping (_ Error : Error? , _ success : Bool)->Void){
        
        let url = "http://elzohrytech.com/alamofire_demo/api/v1/register"
        let parameters = ["name":name , "email":email , "password": password , "password_confirmation":password]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completion(error,false)
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    if (json["status"].int == 0){
                        print("invalid account")
                    }else {
                        if let api_token = json["user"]["api_token"].string {
                            helper.saveApiToken(token: api_token)
                            print(api_token)
                            completion(nil , true)
                        }
                    }
                }
        }
        
        
        
        
    }
    
    
}

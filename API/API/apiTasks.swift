//
//  apiTasks.swift
//  WebService
//
//  Created by Maher on 10/3/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class apiTasks: NSObject {

    class func getTask(page:Int=1, completion:@escaping (_ Error:Error? , _ tasks : [Task]? ,_ last_page : Int)->Void){
        
        guard let api_token = helper.getApiToken() else{return}
        
        let url = "http://elzohrytech.com/alamofire_demo/api/v1/tasks"
        let parameters : [String : Any] = ["api_token":api_token , "page" : page]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON{ (response) in
                switch response.result {
                case .failure(let error):
                    completion(error,nil,page)
                    print(error)
                case .success(let value):
                    let json = JSON(value)
//                    print(value)
                    guard let dataArray = json["data"].array else{
                        completion(nil , nil,page)
                        return}
                    var tasks = [Task]()
                    for data in dataArray{
                        
                        if let data = data.dictionary , let task = Task.init(dict: data){
                           tasks.append(task)
                        }
//                        guard let data = data.dictionary else{return}
//                        var task = Task()
//                        task.id = data["id"]?.int ?? 0
//                        task.complete = data["completed"]?.bool ?? false
//                        task.task = data["task"]?.string ?? "maher"
//                        tasks.append(task)
                    }
                    let last_page = json["last_page"].int ?? page
                    completion(nil , tasks , last_page)
                }
        }
    }
    
    
    
    class func addtask(Newtask:Task , completion:@escaping (_ Error : Error? ,_ newtask : Task?)->Void){
       
        guard let api_token = helper.getApiToken() else{
            completion(nil , nil)
            return}
        let url = "http://elzohrytech.com/alamofire_demo/api/v1/task/create"
        let parameters = ["api_token" : api_token , "task" : Newtask.task]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                 completion(error , nil)
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    guard let dataDict = json["task"].dictionary , let task = Task(dict: dataDict) else {
                        completion(nil , nil)
                        return
                    }
                    completion(nil , task)
                   
                }
        }
        
        
    }
    
    class func EditingTask(task:Task , completion : @escaping (_ Error:Error? , _ newTask : Task?)->Void){
        
        
        guard let api_token = helper.getApiToken() else{
            completion(nil , nil)
            return}
        let url = "http://elzohrytech.com/alamofire_demo/api/v1/task/edit"
        let parameters : [String : Any] = [
            //completed and task are optional
            "api_token" : api_token ,
            "task_id" : task.id ,
            "completed":NSNumber(booleanLiteral: task.completed).intValue ,
            "task": task.task
                        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completion(error , nil)
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    guard let dataDict = json["task"].dictionary , let task = Task(dict: dataDict) else {
                        completion(nil , nil)
                        return
                    }
                    completion(nil , task)
                    
                }
        }
    }
    
    
    
    
    
    class func deleteTask(task:Task , completion : @escaping (_ Error:Error? , _ success:Bool)->Void){
        
        
        guard let api_token = helper.getApiToken() else{
            completion(nil , false)
            return}
        let url = "http://elzohrytech.com/alamofire_demo/api/v1/task/delete"
        let parameters : [String : Any] = ["api_token" : api_token , "task_id" : task.id]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    completion(error , false)
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    guard let status = json["status"].toInt , status == 1 else {
                        completion(nil , false)
                        return
                    }
                    completion(nil , true)
                    
                }
        }
    }
    
    
    
}

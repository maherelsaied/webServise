//
//  model.swift
//  WebService
//
//  Created by Maher on 10/3/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import Foundation
import SwiftyJSON

class Task : NSCopying {
   
    
    var id : Int
    var task : String
    var completed : Bool
    
    init(id:Int = 0 , title:String){
        self.id = id
        self.task = title
        self.completed = false
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copytask = Task(id: self.id, title: self.task)
        copytask.completed = self.completed
        return copytask
    }
    init?(dict:[String:JSON]){
        
        guard let id = dict["id"]?.toInt , let task = dict["task"]?.string else{return nil}
        self.id = id
        self.task = task
        self.completed = dict["completed"]?.ToBool ?? false
    }
}

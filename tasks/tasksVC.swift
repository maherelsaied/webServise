//
//  tasksVC.swift
//  WebService
//
//  Created by Maher on 10/3/19.
//  Copyright © 2019 Maher. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class tasksVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    fileprivate let cellIdentifier :String = "cellIdentifier"
    
    var tasks = [Task]()
    var isloading : Bool = false
    var last_page = 1
    var current_page = 1
    lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(uploadtasks), for: .valueChanged)
        return refresher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.separatorInset = .zero
        tableview.contentInset = .zero
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.addSubview(refresher)
        uploadtasks()
        
        let AddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = AddButton
        
        
    }
    @objc func handleAdd(){
        let alert = UIAlertController(title: "Add New Task", message: "Add Title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addTextField { (textfield) in
            textfield.placeholder = "Title"
            textfield.textAlignment = .center
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .destructive, handler: { (Action:UIAlertAction) in
            guard let title = alert.textFields?.first?.text?.trimed , !title.isEmpty else{return}
            // send new task
            self.sendNewTaskToServer(title: title)
        }))
        present(alert , animated : true , completion : nil)
    }
    
    private func sendNewTaskToServer (title : String){
        print("add New Task \(title) To Server")
        let newTask = Task(title: title)
        apiTasks.addtask(Newtask: newTask) { (Error:Error?, task :Task?) in
            if let task = task {
                self.tasks.insert(task, at: 0)
                self.tableview.beginUpdates()
                self.tableview.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                self.tableview.endUpdates()
            }
        }
        
        
    }
    
    
    
    @objc private func uploadtasks(){
        self.refresher.endRefreshing()
        guard !isloading else{return}
        self.isloading = true
        apiTasks.getTask { (Error:Error?, tasks:[Task]?,last_page:Int) in
            self.isloading = false
            if let tasks = tasks {
                self.tasks = tasks
                self.tableview.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    
    fileprivate func loadMore(){
        guard !isloading else{return}
        self.isloading = true
        guard last_page<current_page else {return}
        apiTasks.getTask(page : current_page+1) { (Error:Error?, tasks:[Task]?,last_page:Int) in
            self.isloading = false
            if let tasks = tasks {
                self.tasks.append(contentsOf: tasks)
                self.tableview.reloadData()
                self.current_page += 1
                self.last_page = last_page
            }
            
        }
    }
}
extension tasksVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.task
        cell.backgroundColor = task.completed ? .yellow : .clear
        return cell
    }
    
    
}
extension tasksVC : UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        let Edittask = task.copy() as! Task
        Edittask.completed = !Edittask.completed
        print("//////////////////////")
        print( Edittask.completed)
        apiTasks.EditingTask(task: Edittask){ (Error:Error?, Editedtask:Task?) in
            if let Editedtask = Editedtask {
               
                self.tasks.remove(at: indexPath.row)
                self.tasks.insert(Editedtask, at: indexPath.row)
                self.tableview.beginUpdates()
                self.tableview.reloadRows(at: [indexPath], with: .automatic)
                self.tableview.endUpdates()
                
            }else {
                //alert error faild to edit
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.tasks.count
        if indexPath.row == count-1 {
            loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = tasks[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (Action:UITableViewRowAction, IndexPath:IndexPath) in
            
            // delete row in tableview
            self.deletetask(task: task, indexpath: indexPath)
        }
        deleteAction.backgroundColor = .red
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (Action:UITableViewRowAction, IndexPath:IndexPath) in
            // edit row in table view
            self.edittask(task: task, indexpath: indexPath)
        }
        editAction.backgroundColor = .lightGray
        
        return [deleteAction , editAction]
    }
    
    private func deletetask(task:Task , indexpath:IndexPath){
        apiTasks.deleteTask(task: task) { (Error:Error?, success:Bool) in
            if success {
                self.tasks.remove(at: indexpath.row)
                self.tableview.beginUpdates()
                self.tableview.deleteRows(at: [indexpath], with: .automatic)
                self.tableview.endUpdates()
            }
            else {
                // alert to show user the error
            }
        }
    }
    
    private func edittask(task : Task , indexpath : IndexPath){
        
        let alert = UIAlertController(title: "Edit New Task", message: "Edit Title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addTextField { (textfield) in
            textfield.text = task.task
            textfield.placeholder = "Title"
            textfield.textAlignment = .center
        }
        
        alert.addAction(UIAlertAction(title: "Edit", style: .destructive, handler: { (Action:UIAlertAction) in
            guard let title = alert.textFields?.first?.text?.trimed , !title.isEmpty else{return}
            // send new Editing task to server
            let newtask = task.copy() as! Task
            newtask.task = title
            apiTasks.EditingTask(task: newtask, completion: { (Error:Error?, Editedtask:Task?) in
                if let Editedtask = Editedtask {
                    //replace new task with old task
                    self.tasks.remove(at: indexpath.row)
                    self.tasks.insert(Editedtask, at: indexpath.row)
                    self.tableview.beginUpdates()
                    self.tableview.reloadRows(at: [indexpath], with: .automatic)
                    self.tableview.endUpdates()
                    
                }else {
                    //alert error faild to edit
                }
            })
            
            
            
        }))
        present(alert , animated : true , completion : nil)
    }
    
    
}



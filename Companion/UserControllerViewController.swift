//
//  UserControllerViewController.swift
//  Companion
//
//  Created by Jordan BOYER on 1/18/18.
//  Copyright © 2018 Jordan BOYER. All rights reserved.
//

import UIKit


import Alamofire
import SwiftyJSON

class UserControllerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var token : String?
    var userName : String?
    var userInfo = [[String:AnyObject]]()
    var UserInfo : [User] = []
    var ProjectInfo : [Project] = []
    
    func treatUser(arr: [User]){
        self.UserInfo = arr
        DispatchQueue.main.async {
            self.UserTable.reloadData()
        }
    }
    
    func treatProjects(arr: [Project]) {
                                      print("fais un project")
        print("Count:")
        print(ProjectInfo.count)
        self.ProjectInfo = arr
        DispatchQueue.main.async {
            self.ProjectTable.reloadData()
        }
    }
    
    func getUserInfo() -> Void {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(self.token!)",
            "forHTTPHeaderField": "Authorization"
        ]
        
        Alamofire.request("https://api.intra.42.fr/v2/users/\(self.userName!)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
                case .success:
                    if let value = response.result.value {
                        let tableUser = JSON(value)
                        let err = tableUser["error"].string
                        if err != nil {
                            let alert = UIAlertController(title: err, message: tableUser["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
                            var Projects = tableUser["projects_users"].arrayValue
                            if (Projects.first?.isEmpty)! {
                                Projects = ["", "50"]
                                print("EMpty broua")
                            }
                            
                            for item in Projects {
                                if item["project"]["name"].isEmpty && item["final_mark"].isEmpty {
                                    self.ProjectInfo.append(
                                        Project(
                                            na: (item["project"]["name"].string)!,
                                            rat: item["final_mark"].int ?? 0
                                        )
                                    )
                                }
                            }
                            
                            self.UserInfo.append(
                                User(
                                    name: (tableUser["login"].string)!,
                                    ln: (tableUser["displayname"].string)!,
                                    mail: (tableUser["email"].string)!,
                                    number: (tableUser["phone"].string)!,
                                    img: (tableUser["image_url"].string)!
                                )
                            )
                            self.treatUser(arr: self.UserInfo)
                            self.treatProjects(arr: self.ProjectInfo)
                        }
                        
                    }
                    case .failure(_):
                            print("Error jojo")
                }
                
            }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    @IBOutlet weak var ProjectTable: UITableView! {
        didSet {
            ProjectTable.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        }
        
    }
    
    @IBOutlet weak var UserTable: UITableView! {
        didSet{
            UserTable.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
        
        self.UserTable.delegate = self
        self.UserTable.dataSource = self
        
        self.ProjectTable.delegate = self
        self.ProjectTable.dataSource = self
        

     
        UserTable.rowHeight = 180
        ProjectTable.rowHeight = 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var tmp : Int?
        
        tmp = 0
        
        if tableView == self.UserTable {
            tmp = UserInfo.count
        }
        else if tableView == self.ProjectTable {
            tmp = ProjectInfo.count
        }
        return tmp!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("indexPath.row : ")
        print(indexPath.row)
        var cell: ProjectTableViewCell?
        
        if indexPath.row == 1 {
            print("cell Project")
            cell = ProjectTable.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectTableViewCell
            cell?.project = self.ProjectInfo[indexPath.row]
        }
            
            
        if tableView == self.UserTable {
            print("cell User")
            let cell = UserTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)  as! UserTableViewCell
            cell.user = self.UserInfo[indexPath.row]
            return cell
        }
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

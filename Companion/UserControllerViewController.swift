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

    @IBOutlet weak var UserImg: UIImageView!
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var LastName: UILabel!
    @IBOutlet weak var Email: UILabel!
    
    @IBOutlet weak var ProjectTable: UITableView!
    
    var token : String?
    var userName : String?
    var userInfo = [[String:AnyObject]]()
    var ProjectInfo : [NewProject] = []
    
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
                        print(tableUser)
                        let err = tableUser["error"].string
                        if err != nil {
                            let alert = UIAlertController(title: err, message: tableUser["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "search", sender: nil)
                            }
                        }
                        else {
                            var Projects = tableUser["projects_users"].arrayValue
                            if (Projects.first?.isEmpty)! {
                                Projects = ["", "50"]
                            }
                            
                            for item in Projects {
                                if item["project"]["name"].isEmpty && item["final_mark"].isEmpty {
                                    if item["status"] == "finished" && 1 == item["cursus_ids"].arrayValue.first! {
                                        self.ProjectInfo.append(
                                            NewProject(
                                                na: (item["project"]["name"].string)!,
                                                rat: (item["final_mark"].int ?? 0)!
                                            )
                                        )
                                    }
                                }
                            }
                            
                            self.Number.text = (tableUser["phone"].string)!
                            self.Name.text = (tableUser["login"].string)!
                            self.LastName.text = (tableUser["displayname"].string)!
                            self.Email.text = (tableUser["email"].string)!
                            
                            //self.treatProjects(arr: self.ProjectInfo)
                            //self.ProjectInfo = arr
                            
                            let imageUrl:URL = URL(string: tableUser["image_url"].string!)!
                            
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                
                                let imageData:NSData = NSData(contentsOf: imageUrl)!
                                
                                DispatchQueue.main.async {
                                    let image = UIImage(data: imageData as Data)
                                    self.UserImg.image = image
                                    self.UserImg.contentMode = UIViewContentMode.scaleAspectFit
                                    // self.view.addSubview(imageView)
                                }
                                DispatchQueue.main.async {
                                    self.ProjectTable.reloadData()
                                }
                            }
                        }
                        
                    }
                    case .failure(_):
                            print("Error jojo")
                }
                
            }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "42_theme")!)
        getUserInfo()
        
        self.ProjectTable.delegate = self
        self.ProjectTable.dataSource = self
        

     
        ProjectTable.rowHeight = 30
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToHome" {
            if let tv = segue.destination as? ViewController {
                tv.token = String("")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ProjectInfo.count)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
        print(ProjectInfo[indexPath.row].name)
        cell.tuple = (ProjectInfo[indexPath.row].name, ProjectInfo[indexPath.row].rating)
        return cell
    }
}

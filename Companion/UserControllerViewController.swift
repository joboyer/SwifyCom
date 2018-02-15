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
    @IBOutlet weak var AchivementTable: UITableView!
    
    var token : String?
    var userName : String?
    var userInfo = [[String:AnyObject]]()
    var ProjectInfo : [NewProject] = []
    var AchievementInfo : [NewAchievement] = []
    var error : Bool = false
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
                                self.performSegue(withIdentifier: "backToHome", sender: nil)
                            }
                        }
                        else {
                            if !tableUser.isEmpty {
                                if (tableUser["projects_users"].exists()) {
                                    let Projects = tableUser["projects_users"].arrayValue
                            
                                    if Projects.isEmpty {
                                        self.ProjectInfo.append(
                                            NewProject(
                                                na: "No Projects found",
                                                rat: 0
                                            )
                                        )
                                    }
                                    else {
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
                                    }
                                }
                            
                                if tableUser["achievements"].exists() {
                                        let Achievements = tableUser["achievements"].arrayValue
                                
                                    if Achievements == nil {
                                        self.AchievementInfo.append(
                                            NewAchievement(
                                                name: "Empty"
                                            )
                                        )
                                    }
                                    else {
                                        for Achi in Achievements {
                                            if Achi["name"].isEmpty {
                                                print(Achi["name"])
                                                self.AchievementInfo.append(
                                                    NewAchievement(
                                                        name: (Achi["name"].string)!
                                                    )
                                                )
                                            }
                                        }
                                    }
                                }
                            
                                if tableUser["phone"] != nil {
                                    self.Number.text = (tableUser["phone"].string)!
                                    self.Number.sizeToFit()
                                }
                                else {
                                    self.Number.text = "0000000000"
                                }
                            
                                if (!(tableUser["login"].string?.isEmpty)!) {
                                    self.Name.text = (tableUser["login"].string)!
                                    self.Name.sizeToFit()
                                }
                                if (!(tableUser["displayname"].string?.isEmpty)!) {
                                    self.LastName.text = (tableUser["displayname"].string)!
                                    self.LastName.sizeToFit()
                                }
                                if (!(tableUser["email"].string?.isEmpty)!) {
                                    self.Email.text = (tableUser["email"].string)!
                                    self.Email.sizeToFit()
                                }
                            //self.treatProjects(arr: self.ProjectInfo)
                            //self.ProjectInfo = arr
        
                            
                                DispatchQueue.global(qos: .userInitiated).async {
                                
                                    if !(tableUser["image_url"].string?.isEmpty)! {
                                        var tmp_img : String?
                                        if tableUser["image_url"].string?.range(of:"default.png") != nil {
                                            tmp_img = "https://straightfromthea.com/wp-content/uploads/2011/09/No.42.jpg"
                                        }
                                        else {
                                            tmp_img = tableUser["image_url"].string
                                        }
                                    
                                        let imageUrl:URL = URL(string: tmp_img!)!
                                        let imageData:NSData = NSData(contentsOf: imageUrl)!
                                    
                                        DispatchQueue.main.async {
                                            let image = UIImage(data: imageData as Data)
                                            self.UserImg.image = image
                                            self.UserImg.contentMode = UIViewContentMode.scaleAspectFit

                                        }
                                        DispatchQueue.main.async {
                                            self.ProjectTable.reloadData()
                                        }
                                        DispatchQueue.main.async{
                                            self.AchivementTable.reloadData()
                                        }
                                    }
                                }
                            }
                            else {
                                self.error = true
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "backToHome", sender: nil)
                                }
                            }
                        }
                        
                    }
                    case .failure(let err):
                        let alert = UIAlertController(title: err.localizedDescription, message: "Error my man", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "backToHome", sender: nil)
                        }
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
        
        self.AchivementTable.delegate = self
        self.AchivementTable.dataSource = self
        
        
     
        ProjectTable.rowHeight = 30
        AchivementTable.rowHeight = 30
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToHome" {
            if let tv = segue.destination as? ViewController {
                tv.token = String("")
                tv.error = self.error
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ProjectTable {
            return (ProjectInfo.count)
        }
        else {
            return (AchievementInfo.count)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath)
        
        if tableView == AchivementTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as? AchievementTableViewCell
            print(AchievementInfo[indexPath.row].AchieNAme)
            cell?.achie = (AchievementInfo[indexPath.row].AchieNAme)
            return cell!
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
        cell.tuple = (ProjectInfo[indexPath.row].name, ProjectInfo[indexPath.row].rating)
        return cell
    }
}

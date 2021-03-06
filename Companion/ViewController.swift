//
//  ViewController.swift
//  Companion
//
//  Created by Jordan BOYER on 1/18/18.
//  Copyright © 2018 Jordan BOYER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var UID: String = "a975c4e405989821cdb9008ef45a43d2ea411818c4954c120e96cabcc2b9191d"
    var secret : String = "6847a5163476f33b3b60b2049131868bc00d4999ec9d78394dc55b3dd733dc25"
    
    var clientToken : String?
    var userToken : String?
    var token : String = ""
    var error : Bool = false
    var tv : UserControllerViewController?
    
    
    @IBOutlet weak var searchString: UITextField!
    
    func checklogin(userName : String?) -> Bool
    {
        let name_reg = "^[A-Za-z]*$"
        
        let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
        if name_test.evaluate(with: userName!) == false || (userName?.isEmpty)! == true
        {
            let alert = UIAlertController(title: "Error", message: "Wrong login format", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
            
            return false
        }
        return true
    }
    
    @IBAction func Search(_ sender: UIButton) {
        if checklogin(userName: self.searchString.text) == true {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "search", sender: self)
            }
        }
    }
    
    func getToken() {
        
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(secret)".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self.token = (dic["access_token"] as? String)!
                            
                            
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            if let tv = segue.destination as? UserControllerViewController {
                tv.token = self.token
                tv.userName = self.searchString.text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.token.isEmpty {
            self.getToken()
        }
        if self.error == true {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "42_theme")!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


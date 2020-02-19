//
//  LoginViewController-Eureka.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 02/02/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka

struct MyVariables {
    static var URL = "http://das.pythonanywhere.com/"
}

class LoginViewController_Eureka: FormViewController {
    
    let urlString = "\(MyVariables.URL)login_mobile"
    
    @IBAction func DonePressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        tableView.backgroundColor = .backgroundColor
        
        form +++ Section("Terms & Conditions")
        
            <<< SwitchRow ("Terms & Conditions") {
                row in
                row.title = "Accept terms & conditions"
                row.disabled = true
        }

        form +++ Section("Login")
            
        <<< TextRow ("ID") {
                row in
                row.title = "Register No."
                row.placeholder = "16bce1234"
        }
        
        <<< PasswordRow ("Pass") {
                row in
                row.title = "Password"
                row.placeholder = "Password"
        }
        
        form +++ Section()
        
        <<< ButtonRow () {
                       row in
                       row.title = "Login"
                   }
        .onCellSelection {
                    (cell, row) in
            
            //Getting row from section
            let ID: TextRow? = self.form.rowBy(tag: "ID")
            let Pass: PasswordRow? = self.form.rowBy(tag: "Pass")
            
            //Checking if it exists
            print(ID?.value as Any)
            print(Pass?.value as Any)
            
            //Check if the values are empty
            if ID?.value != nil && Pass?.value! != nil {
                let id = ID!.value!
                let pass = Pass!.value!
            
                //Parameters
                
                let params : [String : String] = ["username": "\(id)",
                                                "password": "\(pass)",
                                                    ]
                print(params)
                
                //Post request
                let _ = AF.request(self.urlString, method: .post,
                                 parameters: params)
                .responseJSON { response in
                    print("[JSON Response]")
                    print(response)
                
                    if let Data = response.data {
                    let jsonResponse = try? JSON(data: Data)
                    
                    if let json = jsonResponse {
                        //Successful login
                        if json["login"].stringValue == "success" {
                            
                            UserDefaults.standard.set(id, forKey: "ID") //setObject
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            self.performSegue(withIdentifier: "goToFaceID", sender: self)
                        }
                            //Wrong information provided
                        else {
                            let alert = UIAlertController(title: "Error", message: "Please enter correct Registration number/password", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                          
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                        //No response from server
                    else {
                        let alert = UIAlertController(title: "No response from server", message: "Please check your internet connection and try again", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                                                     
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                  }
                }
            }
        }
    }
    
    
}

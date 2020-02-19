//
//  RegisterViewController-Eureka.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 02/02/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class RegisterViewController_Eureka: FormViewController {

    let urlString = "\(MyVariables.URL)/register_mobile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = "Done"
        navigationController?.isNavigationBarHidden = false
        tableView.backgroundColor = .backgroundColor
        
        form +++ Section("Registeration")
            
        <<< TextRow ("ID") {
                row in
                row.title = "Register Number"
                row.placeholder = "Register No."
            }
        
        <<< TextRow ("Name") {
                row in
                row.title = "Name"
                row.placeholder = "Name"
        }
        
        <<< PasswordRow ("Pass") {
                row in
                row.title = "Password"
                row.placeholder = "Password"
        }
        
        <<< EmailRow ("Email") {
                row in
                row.title = "Email"
                row.placeholder = "Email"
        }
        
        form +++ Section("Personal Information")

            <<< TextRow () {
                row in
                row.title = "Coming soon"
                row.placeholder = "..."
                row.disabled  = true
        }

        form +++ Section()
        
            <<< ButtonRow () {
                row in
                row.title = "Register"
            } .onCellSelection { (cell, row) in

                let Name: TextRow? = self.form.rowBy(tag: "Name")
                let ID: TextRow? = self.form.rowBy(tag: "ID")
                let Pass: PasswordRow? = self.form.rowBy(tag: "Pass")
                let Email: EmailRow? = self.form.rowBy(tag: "Email")
                
                print(Name?.value as Any)
                print(ID?.value as Any)
                print(Pass?.value as Any)
                print(Email?.value as Any)

                if Name?.value != nil && ID?.value != nil && Pass?.value! != nil && Email?.value != nil {
                    let name = Name!.value!
                    let id = ID!.value!
                    let pass = Pass!.value!
                    let email = Email!.value!

                    //Parameters for registration

                    let params : [String : String] = ["id": "\(id)",
                                        "name": "\(name)",
                                        "password": "\(pass)",
                                        "email": "\(email)",
                                        "cat": "Student"
                    ]

                    //Post request for registration

                    let _ = AF.request(self.urlString, method: .post,
                                     parameters: params)
                    .responseJSON { response in
                        print("[JSON Response]")
                        print(response)
                    }
                    .responseData { response in
                        print("[Data Response]")
                        print(response)
                    }
                    .responseString { response in
                        print("[String Response]")
                        print(response)
                    }

                    //Alert message for Email Validation

                    let ac = UIAlertController(title: "User registered", message: "Chack your email for verification.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(ac, animated: true)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: "Please enter all fields", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)

                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }
 

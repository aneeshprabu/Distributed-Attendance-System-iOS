//
//  RegisterViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 01/11/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import Alamofire
import CLTypingLabel

class RegisterViewController: UIViewController {
    
    let urlString = "\(MyVariables.URL)/register_mobile"
    @IBOutlet weak var regNo: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = "Distributed Attendance System"
        regNo.delegate = self
        email.delegate = self
        name.delegate = self
        password.delegate = self
        signUpButton.layer.borderColor = self.view.tintColor.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
              
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
       
    }
    
    //MARK: - Deinitialization class
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: - Touches began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        regNo.resignFirstResponder()
        email.resignFirstResponder()
        name.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    
    //MARK: - Keyboard functionality
       
       @objc func keyboardWillShow(notification: NSNotification) {
           
           let modelName = UIDevice.modelName
           
           guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               return
           }
           if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
           {
               if modelName == "iPhone XR" || modelName == "iPhone XS Max" || modelName == "iPhone XS" || modelName == "iPhone X"
               {
                   view.frame.origin.y = -200
               }
               else
               {
                view.frame.origin.y = -keyboardRect.height + 150
            }
           }
           else
           {
               view.frame.origin.y = 0
           }
           
       }
    
    
    //MARK: - SignUp button pressed
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if let ID = regNo.text, let Name = name.text, let Pass = password.text, let Email = email.text {
            
            if ID != "" && Name != "" && Pass != "" && Email != "" {
                 let params : [String : String] = ["id": "\(ID)",
                                     "name": "\(Name)",
                                     "password": "\(Pass)",
                                     "email": "\(Email)",
                                     "cat": "Student"
                 ]
                
                let _ = AF.request(urlString, method: .post,
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
                
                let ac = UIAlertController(title: "User registered", message: "Chack your email for verification.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true) {
                    self.tabBarController?.selectedIndex = 0
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please enter all fields", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                              
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else {
            
            let alert = UIAlertController(title: "Error", message: "Please enter all fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                          
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    

    
}






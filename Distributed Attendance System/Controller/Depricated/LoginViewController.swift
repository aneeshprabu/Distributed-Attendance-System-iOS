//
//  ViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 01/11/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CLTypingLabel




class LoginViewController: UIViewController {
    
    let urlString = "\(MyVariables.URL)login_mobile"
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //MARK: - View did load function

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
    

        titleLabel.text = "Distributed Attendance System"
        print(urlString)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
        loginTextField.delegate = self
        passwordTextField.delegate = self
        loginTextField.tag = 0
        signInButton.layer.borderColor = self.view.tintColor.cgColor
        
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
    
    
    //MARK: - Sign in button tapped
    @IBAction func signInTapped(_ sender: UIButton) {
        sender.isHidden = true
        
        if let ID = loginTextField.text, let Pass = passwordTextField.text {
            
            if ID != "" && Pass != "" {
                 let params : [String : String] = ["username": "\(ID)",
                                                "password": "\(Pass)",
                                                    ]
                
                print(params)
                
                let _ = AF.request(urlString, method: .post,
                                     parameters: params)
                    .responseJSON { response in
                        print("[JSON Response]")
                        print(response)
                         
                        if let Data = response.data {
                            let jsonResponse = try? JSON(data: Data)
                            
                            if let json = jsonResponse {
                                if json["login"].stringValue == "success" {
                                    
                                    UserDefaults.standard.set(ID, forKey: "ID") //setObject
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.performSegue(withIdentifier: "goToFaceID", sender: self)
                                }
                                else {
                                    let alert = UIAlertController(title: "Error", message: "Please enter correct username/password", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                                  
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            else {
                                sender.isHidden = false
                                let alert = UIAlertController(title: "No response from server", message: "Please check your internet connection and try again", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                                                             
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                        }
                    }
            }
            else {
                sender.isHidden = false
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
                view.frame.origin.y = -60
            }
            else
            {
                view.frame.origin.y = -keyboardRect.height + 80
            }
        }
        else
        {
            view.frame.origin.y = 0
        }
        
    }
    
    //MARK: - Touches began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}


//MARK: - UITextField Delegate

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
}





//
//  AttendanceViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 05/11/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        // Do any additional setup after loading the view.
    }
    

}

//
//  WalkthroughContentViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 10/12/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var contentImageView: UIImageView!
    
    //MARK: - Properties
    var index = 0
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        contentImageView.image = UIImage(named: imageFile)

        
    }
    
    
    


}

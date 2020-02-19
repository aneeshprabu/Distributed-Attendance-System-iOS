//
//  WalkthroughViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 10/12/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    

    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    //MARK: - properties
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    
    //MARK: - update UI
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            pageControl.currentPage = index
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        
    }
    

}

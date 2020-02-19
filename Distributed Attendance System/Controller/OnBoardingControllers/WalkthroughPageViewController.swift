//
//  WalkthroughPageViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 10/12/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    

    
    //MARK: - Properties
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    
    var pageImages = ["onBoarding-1", "onBoarding-2", "onBoarding-3"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //set the data source and the delegate to itself
        dataSource = self
        delegate = self
        
        //create the first walkthrough screen
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

    
    }
    
    // MARK:- Page View controller datasource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    //MARK: - helper method
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        
        if index < 0 || index >= pageImages.count {
            return nil
        }
        
        //create new controller and pass data
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            print(pageContentViewController.imageFile)
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    
    //MARK: - Page view controller delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    
}

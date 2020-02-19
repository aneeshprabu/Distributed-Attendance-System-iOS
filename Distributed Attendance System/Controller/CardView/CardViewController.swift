//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

struct subject {
    var name: String
    var code: String
    var classAttended: Float32 
    var classTaken: Float32
    var attendancePercent: Float32 {
        get {
            return (classAttended / classTaken) * 100
        }
    }
}

var list = [subject]()
var optionClicked = 1

class CardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Arrow: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        list.append(contentsOf: [
            subject(name: "Problem Solving", code: "CSE1001", classAttended: 20, classTaken: 24),
            subject(name: "Data Structures and Algorithm", code: "2001", classAttended: 22, classTaken: 24),
            subject(name: "Theory of Computation", code: "CSE3001", classAttended: 10, classTaken: 24)
            ])
        print(list)
        
        
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        cell.textLabel?.text = list[indexPath.row].name
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let destination = CourseViewController()
        print("[Option] User clicked \(list[indexPath.row].name)")
        optionClicked = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
        self.present(vc, animated: true, completion: nil)
        
        //self.present(destination, animated: true, completion: nil)
    }
}


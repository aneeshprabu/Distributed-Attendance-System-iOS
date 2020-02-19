//
//  Student.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 01/11/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import Foundation
import SwiftUI


class student {
    var RegNO:String
    var Name:String
    
    //MARK: - Init class
    
    init(RegistrationNumber RegNO:String, StudentName Name:String) {
        self.RegNO = RegNO
        self.Name = Name
    }
    
    //MARK: - Save the image to document folder
    /**
     This function is used to **save an image** to the document folder
     
     To save an image :
     ```
     let success = saveImage(image: UIImage(named: "image.png")!)
     ```
     To get the saved image:
     ```
     func getSavedImage(named: String) -> UIImage? {
     if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
     return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
     }
     return nil
     }
     ```
     To use the image:
     ```
     if let image = getSavedImage(named: "fileName") {
     //do something with image
     }
     ```
     - Parameter image: Reference image of the user of type UIImage.
     
     */
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    
}

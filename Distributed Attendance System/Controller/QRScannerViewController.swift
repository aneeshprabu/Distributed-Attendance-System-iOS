//
//  QRScannerViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 05/11/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON


//MARK: - Alert class
public class Alert {
    class func alert(userTitle: String?, userMessage: String, userOptions: String, in vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: userTitle, message: userMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: userOptions, style: UIAlertAction.Style.default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}


//MARK: - QR Scanner controller
class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    

    let date = Date()
    let calendar = Calendar.current
    
    
    let urlString = "\(MyVariables.URL)/qrcode_process"
    

    
    
    //MARK: - View did load
    

    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
        
        print("[RegNo Print here]")
        print(UserDefaults.standard.string(forKey: "ID") ?? "ID not found")
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        ///QR starts running.
        captureSession.startRunning()
    }

    /// If scanning is not supported
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    ///What happens when view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    ///What happens when view will dissapear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    ///Capture meta data from Capture output.
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        //dismiss(animated: true)
    }
    
    /// Get today date as String
     func getTodayString() -> String{
        // get the current date and time
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()

        // get the date time String from the date object
        // "10:52:30"
        formatter.dateFormat = "HH:mm:ss"
        let stringDate = formatter.string(from: currentDateTime)
        print("[User Readable Current Time]\(stringDate)")
    
        return stringDate

    }
    

    //MARK: - Function QR found
    
    ///Function that will manipulate the string if it is found from QR Code.
    func found(code: String) {
        print(code)
        
        
        ///Getting current time using getTodayString function
        let today = getTodayString()

        ///Parsing components from QR String using delimiter "|" and storing it in array.
        let timeStringArr = code.components(separatedBy: "|")
        
        ///Getting QR time from components.
        let QRtimeString = timeStringArr[0]
        
        ///Getting offset from components.
        let offsetString = Int(timeStringArr[2])
        print("[User Readable QR Time] \(QRtimeString)")
        
        ///Initializing date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        ///Converting string to Date for QR Time.
        let QRTime = dateFormatter.date(from: QRtimeString)!
        let CurrentTime = dateFormatter.date(from: today)!
        print("[Current Time] -> \(CurrentTime)")
        print("[QR Time] -> \(QRTime)")
        
        ///Calculating time difference between current time and QR generated time.
        let r = CurrentTime.timeIntervalSince(QRTime)
        print("Time inverval \(r)")
        
        ///Checking if the difference is greater or less than the 5 seconds of QR creation
        if let offset = offsetString {
            if r > Double(5 * (offset+1)) {
                let ac = UIAlertController(title: "QR Expired", message: "The scanned QR code has expired", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    
                    self.dismiss(animated: true, completion: nil)
                } ))
                self.present(ac, animated: true)
            }
            else {
                /// Getting stored UserDefault "ID".
                 if let regNo : String = UserDefaults.standard.string(forKey: "ID") {
                    
                    print("[Loaded UserDefault 'ID'] -> regNo")
                    let params : [String:String] = ["details" : code,
                                                    "reg_no" : regNo]
                    
                    ///Post request for posting attendance.
                    let _ = AF.request(urlString, method: .post,
                                         parameters: params)
                        .responseJSON { response in
                            
                            print(response)
                            if let Data = response.data {
                                let jsonResponse = try? JSON(data: Data)

                                if let json = jsonResponse {
                                    //Successful login
                                    if json["status"].stringValue == "attendance posted" {
                                        self.performSegue(withIdentifier: "goToAttendance", sender: self)
                                    }
                                    
                                    else {
                                        let ac = UIAlertController(title: "Attendance already posted", message: "You can't post attendance for yourself again!", preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(ac, animated: true)
                                    }
                                }
                            }
                            else {
                                let ac = UIAlertController(title: "Error", message: "You can't post attendance for yourself again!", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(ac, animated: true)
                            }
                        }
                    
//                    performSegue(withIdentifier: "goToAttendance", sender: self)
                }
                else {
                    
                    let ac = UIAlertController(title: "Register number missing", message: "Please restart application or contact support", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                
                }
            }
        }
        

    }
    
    
    ///Hidding status bar.
    override var prefersStatusBarHidden: Bool {
        return true
    }

    ///Locked to portrait mode.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}



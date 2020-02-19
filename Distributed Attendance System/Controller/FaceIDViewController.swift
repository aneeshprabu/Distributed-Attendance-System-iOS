//
//  FaceIDViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 04/11/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import LocalAuthentication



class FaceIDViewController: UIViewController {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    //MARK: - Initialize
    
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var LockedText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var cardViewController: CardViewController!
    var visualEffectView: UIVisualEffectView!
    
    
    let cardHeight:CGFloat = 650
    let cardHandleAreaHeight:CGFloat = 70
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        LockedText.textColor = .white
        descriptionText.textColor = .white
        
        UserDefaults.standard.set(true, forKey: "didViewLogin")
        print("[UserDefaultValue - FaceID] didViewLogin = \(UserDefaults.standard.bool(forKey: "didViewLogin"))")
        
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
        
        setupCard()
        
        
    }
    
    //MARK: - Card setup function
    
    func setupCard() {
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(FaceIDViewController.handleCardTap(recognizer:)))
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(FaceIDViewController.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    //MARK: - Tap gesture
    @objc
    func handleCardTap (recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
            
        default:
            break
        }
    }
    
    //MARK: - Pan gesture
    @objc
    func handleCardPan (recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
            
        case .began:
            //start Transition
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            //update Transition
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
        case .ended:
            //continue Transition
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    //MARK: - Animation of transition
    
    func animateTransitionIfNeeded (state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                switch state {
                    
                case .expanded:
                    let modelName = UIDevice.modelName
                    if modelName == "iPhone XR" || modelName == "iPhone XS Max" || modelName == "iPhone XS" || modelName == "iPhone X" || modelName == "iPhone 11" || modelName == "iPhone 11 Pro" || modelName == "iPhone Pro Max" {
                        self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight - 100
                    }
                    else {
                        self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 100
                    }
                    self.cardViewController.view.backgroundColor = .backgroundColor
                    self.cardViewController.Arrow.image = UIImage(systemName: "arrow.down")
                    self.cardViewController.view.layer.borderColor = UIColor.systemBlue.cgColor
                    self.cardViewController.view.layer.borderWidth = 0.5
                    self.cardViewController.view.layer.shadowColor = UIColor.black.cgColor
                    self.cardViewController.view.layer.masksToBounds = false
                    self.cardViewController.view.layer.shadowOpacity = 0.5
                    self.cardViewController.view.layer.shadowOffset = CGSize(width: -1, height: 1)
                    self.cardViewController.view.layer.shadowRadius = 1

                    
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                    self.cardViewController.view.backgroundColor = .systemBlue
                    self.cardViewController.Arrow.image = UIImage(systemName: "arrow.up")
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    //MARK: - Three transition functions
    
    func startInteractiveTransition (state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            //run Animations
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition (fractionCompleted: CGFloat){
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
        
    }
    
    func continueInteractiveTransition () {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    //MARK: - Logout function
    
    @objc func logout() {
        if let navController = self.navigationController {
            if navController.topViewController is QRScannerViewController {
                navController.popViewController(animated: true)
                self.tryAgainButton.setTitle("Biometric ID", for: .normal)
            }
            
            if navController.topViewController is AttendanceViewController {
                navController.popViewController(animated: true)
                navController.popViewController(animated: true)
                self.tryAgainButton.setTitle("Biometric ID", for: .normal)
            }
        }
        self.tryAgainButton.setTitle("Biometric ID", for: .normal)
        self.lockImage.image =  UIImage(systemName: "lock.fill")
        self.LockedText.text = "Distributed Attendance System locked"
        self.descriptionText.text = "Unlock with Biometric ID to open D.A.S"
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        beginFaceID()
    }
    
    //MARK: - Begin FaceID
    
    func beginFaceID() {

        guard #available(iOS 8.0, *) else {
            return print("Not supported")
        }

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return print(error as Any)
        }

        let reason = "Biometric authentication"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
            guard isAuthorized == true else {
                DispatchQueue.main.async(execute: {

                    self.tryAgainButton.setTitle("Biometric ID", for: .normal)
                    
                })
                return print(error as Any)
            }
            if isAuthorized {

                print("success")
                
                DispatchQueue.main.async(execute: {
                    
                    Timer.scheduledTimer( timeInterval: 20, target: self, selector: #selector(FaceIDViewController.logout), userInfo: nil, repeats: false)
                    self.tryAgainButton.tag = 2
                    self.lockImage.image =  UIImage(systemName: "lock.open.fill")
                    self.LockedText.text = "Distributed Attendance System Unlocked"
                    self.descriptionText.text = "Please press the button below to scan the QR for course attendance"
                    
                    self.tryAgainButton.setTitle("Scan QR", for: .normal)
                    
                })
            }
            
        }

    }
    
    //MARK: - Try again pressed
    
    @IBAction func tryAgainPressed(_ sender: UIButton) {
        
        if self.tryAgainButton.titleLabel?.text == "Biometric ID" {
            
            self.tryAgainButton.titleLabel?.text = "Biometric ID"
            beginFaceID()
        }
        else if self.tryAgainButton.titleLabel?.text == "Scan QR" {
            performSegue(withIdentifier: "goToQR", sender: self)

        }
        
    }

}

//
//  CourseViewController.swift
//  Distributed Attendance System
//
//  Created by Aneesh Prabu on 09/01/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
 
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Attendance"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    //MARK: - Labels
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var classesAttended: UILabel!
    
    //MARK: - Stepper pressed Function
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let value = Float32(sender.value)
        classesAttended.text = String(Int(sender.value))
        
        let oldAttended = list[optionClicked].classAttended
        let oldTaken = list[optionClicked].classTaken
        
        
        
        list[optionClicked].classAttended += value
        list[optionClicked].classTaken += abs(value)
        print("[Calc percent] \(list[optionClicked].classAttended/list[optionClicked].classTaken)")
        
        animateCircle()
        
        list[optionClicked].classTaken = oldTaken
        list[optionClicked].classAttended = oldAttended
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = UIColor.backgroundColor
        attendanceLabel.text = "\(list[optionClicked].name)"
     
        setupCircleLayers()
        handleTap()
        setupPercentageLabel()

       
    }
    

    
    @objc
    private func barButtonItemPressed () {
        
    }
    
    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.textColor = .white
        percentageLabel.center = view.center
    }
    
    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    @objc
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        let attendancePercent: CGFloat = CGFloat(list[optionClicked].attendancePercent)
        print(attendancePercent)
        
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 32)
        percentageLabel.text = "\(String(format: "%.1f", attendancePercent))%"
        
        if attendancePercent > 75 {
            shapeLayer.strokeColor = UIColor.green.cgColor
        }
        else if attendancePercent < 75 {
            shapeLayer.strokeColor = UIColor.red.cgColor
        }
        shapeLayer.strokeEnd = attendancePercent/100
        
        basicAnimation.toValue = attendancePercent/100
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "attendance")
    }
    
        @objc private func handleTap() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.animateCircle()
            })
        }
}

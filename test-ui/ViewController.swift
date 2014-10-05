//
//  ViewController.swift
//  test-ui
//
//  Created by Alejandro Barros on 04/10/14.
//  Copyright (c) 2014 Filtercode. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var customButton: CustomButton!
    
    var tapGesture: UITapGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    var lastLocation: CGPoint!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        
        panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGesture.delegate = self
        
        customButton.addGestureRecognizer(tapGesture)
        customButton.addGestureRecognizer(panGesture)
        
        lastLocation = customButton.center
        
        super.viewDidLoad()
    }
    
    // MARK: - Gestures
    func handleTap(sender: UITapGestureRecognizer) {
        if customButton.state == CustonButtonState.collapsed {
            customButton.expand()
            lastLocation = customButton.center
        } else {
            customButton.collapse()
            lastLocation = customButton.center
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        if customButton.state == CustonButtonState.expanded {
            let translation =  sender.translationInView(self.view)
            if lastLocation.y + translation.y <= (self.view.bounds.height - customButton.frame.height)  && lastLocation.y + translation.y >= customButton.frame.height {
                customButton.center = CGPoint(x: customButton.center.x, y: customButton.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: self.view)
            }
            
            if sender.state == UIGestureRecognizerState.Ended {
                
                let velocity = sender.velocityInView(self.view)
                let magnitude = CGFloat(sqrtf(Float(velocity.y * velocity.y)))
                let slideMultiplier = magnitude / 200.0
                let slideFactor = 0.1 * slideMultiplier
                
                var finalPoint = CGPoint(
                    x: customButton.center.x,
                    y: customButton.center.y + (velocity.y * slideFactor)
                )
                
                finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width);
                finalPoint.y = min(max(finalPoint.y, customButton.frame.height), self.view.bounds.size.height - customButton.frame.height);
                
                UIView.animateWithDuration(NSTimeInterval(slideFactor), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.customButton.center = finalPoint
                }, completion: nil)
            }
        }
    }
}
//
//  CustomButton.swift
//  test-ui
//
//  Created by Alejandro Barros on 04/10/14.
//  Copyright (c) 2014 Filtercode. All rights reserved.
//

import UIKit

/**
    Custom button possible states
*/
enum CustonButtonState {
    case collapsed
    case expanded
}
    
/**
 Custom Button Class
*/
@IBDesignable public class CustomButton: UIView {
    // MARK: - Properties
    var state: CustonButtonState
    var spheres = [CustomSphere]()
    let originalSize: CGSize!
    let originalCenter: CGPoint!
    
    // MARK: - Animation properties
    @IBInspectable var animationDuration: Float = 0.8
    @IBInspectable var animationDelay: Float = 0.0
    @IBInspectable var animationSpringDamping: CGFloat = 0.7
    @IBInspectable var animationSpringVelocity: CGFloat = 0.5
    
    // MARK: - Control properties
    @IBInspectable var numberOfSpheres: Int = 4
    @IBInspectable var sphereDiameter: Float = 25.0
    @IBInspectable var sphereColor: UIColor = UIColor.grayColor()
    
    // MARK: - UIView
    override init(){
        state = .collapsed
        
        super.init()
        
        originalSize = self.frame.size
        originalCenter = self.frame.origin
        
        var index = 1
        while index <= numberOfSpheres {
            var sphere = CustomSphere(frame: CGRectMake(0, 0, CGFloat(sphereDiameter), CGFloat(sphereDiameter)), color: UIColor.greenColor())
            spheres.append(sphere)
            sphere.clipsToBounds = true
            sphere.backgroundColor = UIColor.clearColor()
            sphere.alpha = 0
            addSubview(sphere)
            index++
        }
    }

    required public init(coder aDecoder: NSCoder) {
        state = .collapsed
        
        super.init(coder: aDecoder)
        
        originalSize = self.frame.size
        originalCenter = self.frame.origin
        
        var index = 1
        while index <= numberOfSpheres {
            var sphere = CustomSphere(frame: CGRectMake(0, 0, CGFloat(sphereDiameter), CGFloat(sphereDiameter)), color: UIColor.greenColor())
            spheres.append(sphere)
            sphere.clipsToBounds = true
            sphere.backgroundColor = UIColor.clearColor()
            sphere.alpha = 0
            addSubview(sphere)
            index++
        }
    }
    
    // MARK: - Drawing methods
    override public func drawRect(rect: CGRect)
    {
        var ovalPath = UIBezierPath(ovalInRect: self.bounds)
        UIColor.grayColor().setFill()
        ovalPath.fill()
    }
    
    // MARK: - Public methods
    public func expand() {
        expandControl()
        state = .expanded
    }
    
    public func collapse() {
        collapseControl()
        state = .collapsed
    }
    
    // MARK: - Internal methods
    internal func expandControl() {
        
        let circunference: Float = self.sphereDiameter * Float(M_PI)
        let segment = circunference / Float(numberOfSpheres)
        let kAngleOffset = M_PI / 2
        
        UIView.animateWithDuration(NSTimeInterval(animationDuration), delay: NSTimeInterval(animationDelay), usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationSpringVelocity, options: .CurveLinear,
            animations: {
                
                self.frame = CGRectMake(
                    self.frame.origin.x - self.frame.size.width / 2,
                    self.frame.origin.y - self.frame.size.height / 2,
                    self.frame.size.width * 2,
                    self.frame.size.height * 2
                )
                
                for (index, sphere) in enumerate(self.spheres) {
                    
                    var angle = CGFloat(M_PI + (M_PI_2 - kAngleOffset) + Double(index) * kAngleOffset)
                    var point = CGPoint(
                        x: sphere.frame.origin.x + CGFloat(cos(angle)) * CGFloat(self.originalSize.width * 2) - (sphere.frame.origin.x - self.frame.size.width / CGFloat(self.numberOfSpheres)),
                        y: sphere.frame.origin.y + CGFloat(sin(angle)) * CGFloat(self.originalSize.width * 2) - (sphere.frame.origin.y - self.frame.size.height / CGFloat(self.numberOfSpheres))
                    )
                   
                    sphere.frame = CGRect(origin: point, size: sphere.frame.size)
                    sphere.alpha = 1
                }
        },
        completion: nil)
    }
    
    internal func collapseControl() {
        UIView.animateWithDuration(NSTimeInterval(animationDuration), delay: NSTimeInterval(animationDelay), usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationSpringVelocity, options: .CurveLinear,
            animations: {
                self.frame = CGRectMake(
                    self.frame.origin.x + self.originalSize.width / 2,
                    self.frame.origin.y + self.originalSize.height / 2,
                    self.frame.size.width / 2,
                    self.frame.size.height / 2
                )
                
                for sphere in self.spheres {
                    sphere.frame = CGRectMake(
                        0,
                        0,
                        sphere.frame.size.width,
                        sphere.frame.size.height
                    )
                    sphere.alpha = 0
                }
            },
            completion: nil)
    }
}


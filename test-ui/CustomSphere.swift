//
//  CustomSphere.swift
//  test-ui
//
//  Created by Alejandro Barros on 04/10/14.
//  Copyright (c) 2014 Filtercode. All rights reserved.
//

import UIKit

class CustomSphere: UIView {
    
    // MARK: - Properties
    var fillColor: UIColor = UIColor.grayColor()
    
    // MARK: - UIView
    init(frame: CGRect, color: UIColor) {
        
        fillColor = color
        
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect)
    {
        var ovalPath = UIBezierPath(ovalInRect: self.bounds)
        fillColor.setFill()
        ovalPath.fill()
    }
}

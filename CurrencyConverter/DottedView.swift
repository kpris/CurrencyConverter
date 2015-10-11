//
//  DottedView.swift
//  CurrencyConverter
//
//  Created by Priscilla Bevis on 11/10/2015.
//  Copyright © 2015 Priscilla. All rights reserved.
//

import UIKit

@IBDesignable
class DottedView: UIView {
    
    @IBInspectable var colour: UIColor = UIColor.whiteColor()

    override func drawRect(rect: CGRect) {
        
        let thickness = rect.height
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, thickness)
        CGContextSetStrokeColorWithColor(context, colour.CGColor)
        CGContextSetLineDash(context, 0, [8.0, 6.0], 2)
        
        CGContextMoveToPoint(context, 0, (thickness/2))
        CGContextAddLineToPoint(context, self.bounds.size.width, thickness*0.5);
        CGContextStrokePath(context);
    }

}

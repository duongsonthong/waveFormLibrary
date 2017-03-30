//
//  UtilFunction.swift
//
//  Created by SSd on 11/12/16.
//

import UIKit

class UtilFunction: NSObject {
    
    public func createCirclePath(arcCenter: CGPoint,
                          radius: CGFloat,
                          startAngle: CGFloat,
                          endAngle: CGFloat,
                          clockwise: Bool) -> UIBezierPath {
        
        return UIBezierPath(arcCenter: arcCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: clockwise)
    }
    public func createTrianglePath(x1: CGPoint,x2 : CGPoint,x3: CGPoint) -> UIBezierPath{
        let closePath = UIBezierPath()
        closePath.move(to: x1)
        closePath.addLine(to: x2)
        closePath.addLine(to: x3)
        closePath.addLine(to: x1)
        return closePath
    }
    
}

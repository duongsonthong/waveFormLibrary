//
//  PlayButtonView.swift
//  Created by SSd on 11/15/16.
//

import UIKit

class PlayButtonView: UIButton {

   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    let mFrame : CGRect
    let utilFunction = UtilFunction()
    var isPlayStatus : Bool = false
    var fillColor = UIColor(red: 225/255, green: 216/255, blue: 227/255, alpha: 1.0)
    let caShape = CAShapeLayer()
    let triangleShape = CAShapeLayer()
    override init(frame: CGRect) {
        mFrame = frame
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        caShape.frame = CGRect(x: 0, y: 0, width: mFrame.width, height: mFrame.height)
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat(2.0 * M_PI)
        let clockwise = true
        let circlePath = utilFunction.createCirclePath(arcCenter: CGPoint(x: mFrame.size.width/2,y : mFrame.size.height/2), radius: mFrame.size.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        caShape.fillColor = fillColor.cgColor
        caShape.path = circlePath.cgPath
        
        //triangle 
        let triangleWidth = mFrame.width/2
        let xPosition = isPlayStatus ? caShape.frame.width/2-triangleWidth/2 : caShape.frame.width/2-triangleWidth/2+caShape.frame.width/10
        triangleShape.frame = CGRect(x: xPosition, y: caShape.frame.width/2-triangleWidth/2, width: triangleWidth, height:triangleWidth)
        var path = UIBezierPath()
        if isPlayStatus {
            //playing
            let lineWidth = triangleWidth/3
            path.move(to: CGPoint(x: lineWidth/2, y: 0))
            path.addLine(to: CGPoint(x: lineWidth/2, y: triangleWidth))
            path.close()
            path.move(to: CGPoint(x: triangleWidth-lineWidth/2, y: 0))
            path.addLine(to: CGPoint(x: triangleWidth-lineWidth/2, y: triangleWidth))
            path.close()
            triangleShape.lineWidth = lineWidth
        }else {
            //pause
            triangleShape.lineWidth = CGFloat(1)
            let x1 = CGPoint(x: 0, y: 0)
            let x2 = CGPoint(x: 0, y: triangleWidth)
            let x3 = CGPoint(x: triangleWidth, y: triangleWidth/2)
            path = utilFunction.createTrianglePath(x1: x1, x2: x2, x3: x3)

        }
        
        triangleShape.strokeColor = UIColor.white.cgColor
        triangleShape.path = path.cgPath
        triangleShape.fillColor = UIColor.white.cgColor
        triangleShape.backgroundColor = UIColor.clear.cgColor
        
        caShape.addSublayer(triangleShape)
       
        layer.addSublayer(caShape)
    }
    
    public func setPlayStatus(isPlay : Bool){
        isPlayStatus = isPlay
        self.setNeedsDisplay()
    }

}

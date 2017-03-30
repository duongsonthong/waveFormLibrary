//
//  CustomButtom.swift
//  HalfTunes
//
//  Created by SSd on 10/30/16.
//

import UIKit

protocol ButtonMoveProtocol {
    func buttonTouchesBegan(position : Int,isLeft : Bool)
    func buttonTouchesMoved(position : Int,isLeft : Bool)
    func buttonTouchesEnded(position : Int,isLeft : Bool)
}

class CustomButtom: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let parentView : UIView?
    let controllFormView :ControllerWaveForm
    var type : Bool = false
    let delegateButton : ButtonMoveProtocol?
    var touchInsideButton : CGFloat = 0
    var parentWidth : CGFloat = 0
    var mFrame : CGRect?
    init(frame: CGRect,parentViewParam : UIView,isLeft : Bool,delegate : ButtonMoveProtocol) {
        parentView = parentViewParam
        parentWidth = parentViewParam.frame.width
        controllFormView = parentView as! ControllerWaveForm
        type = isLeft
        delegateButton = delegate
        mFrame = frame
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touche = touches.first {
            let touchEnd = touche.location(in: parentView).x
            delegateButton?.buttonTouchesEnded(position: Int(touchEnd), isLeft: type)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touche = touches.first {
            let touchesBegan = touche.location(in: parentView).x
            print("touchesBeganx  \(touchesBegan)")
            touchInsideButton = touche.location(in: self).x
            delegateButton?.buttonTouchesBegan(position: Int(touchesBegan), isLeft: type)
        }
    }
    func getWidth() -> Float{
        if let frameUW = mFrame {
            return Float(frameUW.size.width)
        }else {
            return 0
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touche = touches.first {
            let touchMove = touche.location(in: parentView).x
//            print("buttonMove.x  \(touchMove)")
//            print("buttonInside  \(touchInsideButton)")
            let buttonPos = touchMove - touchInsideButton
            if buttonPos > 0 && buttonPos < parentWidth {
                    self.frame.origin.x = buttonPos
            }
            delegateButton?.buttonTouchesMoved(position: Int(touchMove), isLeft: type)
        }
    }
    func updateFramePostion(position : Int)  {
        self.frame.origin.x = CGFloat(position)
    }
}

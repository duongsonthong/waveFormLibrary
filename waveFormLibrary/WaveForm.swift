//
//  childTest.swift
//
//  Created by SSd on 11/3/16.
//

import UIKit

protocol WaveFormProtocol {
   
    func waveformDraw()
}
class WaveForm: UIView {

    let mDelegate : WaveFormProtocol?
    private var caShap : CAShapeLayer
    var x : Int = 0
    init(frame: CGRect,deletgate : WaveFormProtocol?) {
        mDelegate = deletgate
        caShap = CAShapeLayer()
        super.init(frame: frame)
        caShap.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        caShap.position = CGPoint(x: frame.width/2, y: frame.height/2)
        caShap.backgroundColor = UIColor.white.cgColor
        caShap.strokeColor = UIColor.blue.cgColor
        self.layer.addSublayer(caShap)

    }
    override func draw(_ rect: CGRect) {
        print("call draw x = \(x)")
        var point : CGPoint
        let lineTimePath = UIBezierPath()
        point = CGPoint(x: x, y: 0)
        lineTimePath.move(to: point)
        point.y = CGFloat(rect.height)
        lineTimePath.addLine(to: point)
        if let delegate = mDelegate {
            print("set callback")
            delegate.waveformDraw()
        }
        caShap.path = lineTimePath.cgPath
    }
    func setNewPosition(_position : Int)  {
        x = _position
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

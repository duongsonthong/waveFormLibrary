//
//  parentTest.swift
//
//  Created by SSd on 11/3/16.
//

import UIKit

class ControllerWF: UIView {

    var i : Int = 0
    var mWaveForm : WaveForm?
    var playButton : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        mWaveForm = WaveForm(frame: frame, deletgate: self)
        let playButtonRect = CGRect(x: frame.size.width/2-50, y: frame.size.height-100, width: 100, height: 100)
        playButton = UIButton(frame: playButtonRect)
        playButton?.backgroundColor = UIColor.gray
        playButton?.setTitle("play", for: .normal)
        playButton?.addTarget(self, action: #selector(self.clickPlay), for: .touchUpInside)
        addSubview(mWaveForm!)
        addSubview(playButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickPlay(){
        mWaveForm!.setNewPosition(_position: 100)
        mWaveForm!.setNeedsDisplay()// if I click button, waveForm draw new line at new position 100
    }
}
extension ControllerWF : WaveFormProtocol {
    func waveformDraw(){
        if i < 2 {
            print("callback waveformDraw")
            i+=1
            mWaveForm!.setNewPosition(_position: i)
            mWaveForm!.setNeedsDisplay() // the problem here.. waveForm not call draw(:) to redraw line with new position
        }
    }
}


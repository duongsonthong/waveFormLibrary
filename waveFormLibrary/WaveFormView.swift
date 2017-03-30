//
//  WaveFormView.swift
//
//  Created by SSd on 10/26/16.
//

import UIKit

protocol WaveFormMoveProtocol {
    func touchesBegan(position : Int)
    func touchesMoved(position : Int)
    func touchesEnded(position : Int)
}

class WaveFormView: UIView {

    
    private var caShap : CAShapeLayer
    private var caShapMaskTime : CAShapeLayer
    private var caShapUnSelect : CAShapeLayer
    private var urlLocal = URL(fileURLWithPath: "")
    private  var mSoundFile = CheapMp3()
    var mSampleRate: Int = 0
    var mSamplesPerFrame: Int = 0
    var minGain : Float = 0
    var range: Float = 0
    var  mNumZoomLevels : Int = 0
    var  mLenByZoomLevel : [Int]
    var  mZoomFactorByZoomLevel: [Float]
    var scaleFactor : Float = 1
    var mFrame : CGRect?
    var mZoomLevel : Int = 0
    var mInitialized : Bool = false
    var  mSelectionStart : Int = 0
    var mSelectionEnd : Int = 0
    var mOffset : Int = 0
    var mTouchStart : Int = 0
    var mTouchInitialOffset : Int = 0
    var mPlaybackPos : Int = -1
    
    var startTest : Int = 0
    var endTest : Int = 0
    let buttonWidth : Int = 100
    var strokeColor:UIColor = UIColor.white
    var fillColor : UIColor = UIColor.yellow
    var mWaveFormProtocol : WaveFormMoveProtocol?
    //var unSelectColor : UIColor =
    init(frame: CGRect,deletgate : WaveFormMoveProtocol?,waveFormBackgroundColor : UIColor,currentPlayLineColor : UIColor) {
        strokeColor = waveFormBackgroundColor
        fillColor = currentPlayLineColor
        mSelectionEnd = Int(frame.size.width)
        caShap = CAShapeLayer()
        caShapMaskTime = CAShapeLayer()
        caShapUnSelect = CAShapeLayer()
        
        mLenByZoomLevel = Array(repeatElement(0, count: 4))
        mZoomFactorByZoomLevel = Array(repeating: 0, count: 4)
        super.init(frame: frame)
        mFrame = frame
        self.backgroundColor = UIColor.clear
        caShap.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        caShap.position = CGPoint(x: frame.width/2, y: frame.height/2)
        caShap.backgroundColor = UIColor.clear.cgColor
        caShap.strokeColor = strokeColor.cgColor
        
        // select shape
        
        caShapUnSelect.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        caShapUnSelect.position = CGPoint(x: frame.width/2, y: frame.height/2)
        caShapUnSelect.backgroundColor = UIColor.clear.cgColor
        caShapUnSelect.strokeColor = UIColor.gray.withAlphaComponent(0.8).cgColor

        // mask time shape
        
        caShapMaskTime.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        caShapMaskTime.position = CGPoint(x: frame.width/2, y: frame.height/2)
        caShapMaskTime.backgroundColor = UIColor.clear.cgColor
        caShapMaskTime.strokeColor = fillColor.cgColor
        print("frame \(frame.size.height/2)")
//        let button = CustomButtom(frame: CGRect(x: 0, y: 100, width: buttonWidth, height: 50),parentViewParam : self,isLeft : true)
//        button.backgroundColor = UIColor.green
//        button.setTitle("Test Button", for: .normal)
//    
//        let buttonRight = CustomButtom(frame: CGRect(x: frame.size.width-100, y: frame.size.height-100, width: 100, height: 50),parentViewParam : self,isLeft : false)
//        buttonRight.backgroundColor = UIColor.green
//        buttonRight.setTitle("Test Button", for: .normal)
       
       // caShap.fillColor =  UIColor.red.cgColor
        self.layer.addSublayer(caShap)
        self.layer.addSublayer(caShapMaskTime)
        self.layer.addSublayer(caShapUnSelect)
       
//        addSubview(button)
//        addSubview(buttonRight)
        if let delegateProtocol = deletgate {
             mWaveFormProtocol = delegateProtocol
        }
       // self.setNeedsDisplay()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        var point : CGPoint
        let linePath = UIBezierPath()
        let lineTimePath = UIBezierPath()
        let unSelectPath = UIBezierPath()
        let start  = mOffset
        let ctr = Int(rect.height/2)

        if mInitialized{
            for i in 0 ..< Int(rect.width){
               
                let zoomLevelFloat : Float = mZoomFactorByZoomLevel[mZoomLevel]
                let h : Int  = (Int) (getScaledHeight(zoomLevel: zoomLevelFloat , i: start + i ) * Float(getMeasuredHeight() / 2));
               
                let y0 = ctr - h
                let y1 = ctr + 1 + h
                point = CGPoint(x: i, y: y0)
                linePath.move(to: point)
                point.y = CGFloat(y1)
                linePath.addLine(to: point)
                if i+start == mPlaybackPos {
                    //masker time
                    point = CGPoint(x: i, y: 0)
                    lineTimePath.move(to: point)
                    point.y = CGFloat(rect.height)
                    lineTimePath.addLine(to: point)
                    
                }
                // draw unselect 
                if i+start < mSelectionStart || i+start > mSelectionEnd {
                    point = CGPoint(x:i, y: 0)
                    unSelectPath.move(to: point)
                    point.y = CGFloat(rect.height)
                    unSelectPath.addLine(to: point)
                }

            }

            caShap.path = linePath.cgPath
            caShapUnSelect.path = unSelectPath.cgPath
            caShapMaskTime.path = lineTimePath.cgPath
           
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            if let waveformDelegate = mWaveFormProtocol {
                waveformDelegate.touchesBegan(position: Int(touch.location(in: self).x))
            }

        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            let point = touch.location(in: self)
            if let waveformDelegate = mWaveFormProtocol {
                waveformDelegate.touchesMoved(position: Int(point.x))
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.location(in: self)
            if let waveformDelegate = mWaveFormProtocol {
                waveformDelegate.touchesEnded(position: Int(point.x))
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch cancel")
    }
    public func updateStart(x : Float) {
        startTest = Int(x)
        self.setNeedsDisplay()
    }
    public func updateEnd(x : Float) {
        endTest = Int(x) + buttonWidth
        self.setNeedsDisplay()
    }
   
    func setFileUrl(url:URL) throws  {
        urlLocal = url
        try mSoundFile.ReadFile(url: urlLocal)
        mSampleRate = mSoundFile.getSampleRate();
        mSamplesPerFrame = mSoundFile.getSamplesPerFrame();
        computeDoublesForAllZoomLevels();
       
    }
    // init request data
    func computeDoublesForAllZoomLevels(){
        let numFrames = mSoundFile.getNumFrames();
        
        // Make sure the range is no more than 0 - 255
        var maxGain : Float = 1.0
        for i in 0 ..< numFrames {
            let gain = getGain( i: i, numFrames: numFrames, frameGains: mSoundFile.getFrameGains())
            if (gain > maxGain) {
                maxGain = gain
            }
        }
        
        scaleFactor = 1
        if (maxGain > 255.0) {
            scaleFactor = 255 / maxGain
        }
        
        // Build histogram of 256 bins and figure out the new scaled max
        maxGain = 0;
        //int gainHist[] = new int[256]
        var gainHist : [Int]
        gainHist = Array(repeating: 0, count: 256)
        
        for i in 0 ..< numFrames {
            
            var smoothedGain : Int = Int(getGain(i: i, numFrames: numFrames, frameGains: mSoundFile.getFrameGains()) * scaleFactor)
            if (smoothedGain < 0){
                smoothedGain = 0
            }
            if (smoothedGain > 255){
                smoothedGain = 255
            }
            if (Float(smoothedGain) > maxGain){
                maxGain = Float(smoothedGain)
            }
            
            gainHist[smoothedGain] += 1;
            
        }
        
        
        // Re-calibrate the min to be 5%
        minGain = 0
        var sum : Int = 0
        while (minGain < Float(255) && sum < numFrames / 20) {
            sum += gainHist[Int(minGain)];
            minGain+=1;
        }
        
        // Re-calibrate the max to be 99%
        sum = 0;
        while (maxGain > 2 && sum < numFrames / 100) {
            sum += gainHist[Int(maxGain)]
            maxGain-=1;
        }
        
        range = maxGain - minGain;
        
        mNumZoomLevels = 3;
        mLenByZoomLevel = Array(repeatElement(0, count: 4))
        mZoomFactorByZoomLevel = Array(repeating: 0, count: 4)
        
        let ratio : Float = Float(getMeasuredWidth()) / Float(numFrames)
        
        if (ratio < 1) {
            mLenByZoomLevel[0]  = Int(round(Float(numFrames) * ratio))
            
            mZoomFactorByZoomLevel[0] = ratio
            
            mLenByZoomLevel[1] = numFrames
            mZoomFactorByZoomLevel[1] = 1
            
            mLenByZoomLevel[2] = numFrames * 2
            mZoomFactorByZoomLevel[2] = 2
            
            mLenByZoomLevel[3] = numFrames * 3
            mZoomFactorByZoomLevel[3] = 3.0
            
            mZoomLevel = 0;
        } else {
            mLenByZoomLevel[0] = numFrames
            mZoomFactorByZoomLevel[0] = 1
            
            mLenByZoomLevel[1] = numFrames * 2
            mZoomFactorByZoomLevel[1] = 2
            
            mLenByZoomLevel[2] = numFrames * 3
            mZoomFactorByZoomLevel[2] = 3
            
            mLenByZoomLevel[3] = numFrames * 4
            mZoomFactorByZoomLevel[3] = 4
            
            mZoomLevel = 0;
            for i in 0 ..< 4 {
                if (mLenByZoomLevel[mZoomLevel] - getMeasuredWidth() > 0) {
                    break;
                } else {
                    mZoomLevel = i;
                }
            }
        }
        
        mInitialized = true;
    }
    
    //draw waveForm 
    func drawWaveform(){
        
    }
    
    func drawWaveformLine() {
        
    }

    
    func maxPos() -> Int {
         return mLenByZoomLevel[mZoomLevel];
    }
    
    func getGain(i : Int, numFrames : Int, frameGains : [Int]) -> Float {
        let x : Int = min(i, numFrames - 1);
        if (numFrames < 2) {
            return Float(frameGains[x]);
        } else {
            if (x == 0) {
                return (Float(frameGains[0]) / 2) + (Float(frameGains[1]) / 2)
            } else if (x == numFrames - 1) {
                return (Float(frameGains[numFrames - 2]) / 2) + ( Float(frameGains[numFrames - 1]) / 2)
            } else {
                return (Float(frameGains[x - 1]) / 3) + (Float(frameGains[x]) / 3) + (Float(frameGains[x + 1]) / 3)
            }
        }
    }
    
    func getMeasuredWidth()-> Int {
        if let frame = mFrame{
            return Int(frame.width)
        }else{
            return 0
        }
    }
    
    func getMeasuredHeight() -> Int {
        if let frame = mFrame{
            return Int(frame.height)
        }else{
            return 0
        }

    }
    
    func getScaledHeight(zoomLevel : Float, i : Int) -> Float {
        
        if (zoomLevel == 1.0) {
            return getNormalHeight(i: i)
        } else if (zoomLevel < 1.0) {
            return getZoomedOutHeight(zoomLevel: zoomLevel, i: i);
        }
        return getZoomedInHeight(zoomLevel: zoomLevel, i: i);
    }
    
    func getNormalHeight(i : Int) -> Float {
         return getHeight(i: i, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
    }
    
    func getHeight(i : Int,numFrames : Int, frameGains : [Int],scaleFactor : Float,minGain : Float,range : Float) -> Float {
        var value : Float = (getGain(i: i, numFrames: numFrames, frameGains: frameGains) * scaleFactor - minGain) / range;
        if (value < 0.0){
            value = 0
        }
        if (value > 1.0){
            value = 1
        }
        return value;
    }
    // zoom
    func getZoomedOutHeight(zoomLevel : Float,i: Int) -> Float {
        let f = Int(Float(i) / zoomLevel)
        let x1 = getHeight(i: f, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
        let x2 = getHeight(i: f + 1, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
        return 0.5 * (x1 + x2);
    }
    func getZoomedInHeight(zoomLevel : Float, i: Int) -> Float {
        let f =  Int(zoomLevel)
        if (i == 0) {
            return 0.5 * getHeight(i: 0, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
        }
        if (i == 1) {
            return getHeight(i: 0, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
        }
        if (i % f == 0) {
            let x1 = getHeight(i: i / f - 1, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
            let x2 = getHeight(i: i / f, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
            return 0.5 * (x1 + x2);
        } else if ((i - 1) % f == 0) {
            return getHeight(i: (i - 1) / f, numFrames: mSoundFile.getNumFrames(), frameGains: mSoundFile.getFrameGains(), scaleFactor: scaleFactor, minGain: minGain, range: range);
        }
        return 0;

    }
    func canZoomIn() -> Bool {
        return (mZoomLevel < mNumZoomLevels - 1);
    }
   
    func zoomIn()  {
        if (canZoomIn()) {
            mZoomLevel+=1;
            let factor : Float = Float(mLenByZoomLevel[mZoomLevel]) / Float(mLenByZoomLevel[mZoomLevel - 1])
            let factorInt = Int(factor)
            mSelectionStart *= factorInt // TODO check it out
            mSelectionEnd *= factorInt
            var offsetCenter: Int  = mOffset + getMeasuredWidth() / factorInt
            offsetCenter *= factorInt;
            mOffset = offsetCenter - getMeasuredWidth() / factorInt;
            if (mOffset < 0){
                mOffset = 0
            }
            self.setNeedsDisplay()
        }

    }
    
    func canZoomOut() -> Bool {
        return (mZoomLevel > 0)
    }
    
    func zoomOut(){
        if (canZoomOut()) {
            mZoomLevel-=1;
            let factor : Float = Float(mLenByZoomLevel[mZoomLevel + 1]) / Float(mLenByZoomLevel[mZoomLevel])
            let factorInt = Int(factor)
            mSelectionStart /= factorInt;
            mSelectionEnd /= factorInt;
            var offsetCenter =  Int(mOffset + getMeasuredWidth() / factorInt);
            offsetCenter /= factorInt
            mOffset = offsetCenter -  Int(getMeasuredWidth() / factorInt);
            if (mOffset < 0){
                mOffset = 0
            }
            self.setNeedsDisplay()
        }
    }
   
    // touch event 
    func trap(pos : Int) -> Int {
        if (pos < 0){
            return 0
        }
        if (pos > maxPos() ){
            return maxPos();
        }
        return pos;
            

    }
    
    // Play event   
    func setPlayback(pos : Int)  {
        mPlaybackPos = pos
    }
    
    func millisecsToPixels(msecs : Int) -> Int {
        let z : Double = Double(mZoomFactorByZoomLevel[mZoomLevel])
        let first = Double(msecs) * 1.0 * Double(mSampleRate) * z
        let last = (1000.0 * Double(mSamplesPerFrame)) + 0.5
        return Int(first/last)
        
    }
    
    func setParameters(start : Int, end : Int, offset : Int) {
        mSelectionStart = start
        mSelectionEnd = end
        mOffset = offset
    }
    
    func getStart() -> Int {
        return mSelectionStart
    }
    
    func getEnd() -> Int{
        return mSelectionEnd
    }
    // Play convert
    func pixelsToMillisecs(pixels : Int) -> Int {
        let z : Double = Double(mZoomFactorByZoomLevel[mZoomLevel])
        print(pixels)
        print(mSamplesPerFrame)
        let first : Float = Float (pixels) * Float(1000 * mSamplesPerFrame)
        let second = (Double(mSampleRate) * z) + 0.5
        return Int( Double(first)/second )
    }
    
    // get value
    
    func getOffset() -> Int {
        return mOffset
    }
   
}

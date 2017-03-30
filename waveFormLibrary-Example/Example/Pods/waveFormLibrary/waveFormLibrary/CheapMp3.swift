//
//  CheapMp3.swift
//
//  Created by SSd on 10/20/16.

import Foundation

class CheapMp3: NSObject {
    
    var fileManager = FileManager()
    
    // Member variables representing frame data
    var  mNumFrames = Int()
    var mFrameGains = [Int]()
    
    
    var mFileSize = Int();
    var mAvgBitRate = Int();
    var mGlobalSampleRate = Int();
    var mGlobalChannels = Int();
    
    // Member variables used during initialization
    var mMaxFrames = Int();
    var mBitrateSum = Int();
    var mMinGain = Int();
    var mMaxGain = Int();
    
    // get values function
    public func getNumFrames() ->Int {
        return mNumFrames;
    }
    
    public func getSamplesPerFrame() ->Int {
        return 1152;
    }
    
    public func getFrameGains()-> [Int] {
        return mFrameGains;
    }
    
    public func getFileSizeBytes()-> Int {
        return mFileSize;
    }
    
    public func getAvgBitrateKbps()-> Int {
        return mAvgBitRate;
    }
    
    public func getSampleRate() ->Int {
        return mGlobalSampleRate;
    }
    
    public func getChannels() -> Int {
        return mGlobalChannels;
    }
    
    public func getFiletype() -> String {
        return "MP3";
    }
    
    public func ReadFile(url : URL) throws{
        mNumFrames = 0
        mMaxFrames = 64  // This will grow as needed
        mFrameGains  = Array(repeating: 0, count: mMaxFrames)
        mBitrateSum = 0
        mMinGain = 255
        mMaxGain = 0
        var pos : Int = 0
        var offset : Int = 0
        var buffer = Data()
        let file = try FileHandle(forReadingFrom: url)
        mFileSize = file.availableData.count
        file.seek(toFileOffset: 0)
        
      
        
        while (pos < mFileSize - 12) {
            // Read 12 bytes at a time and look for a sync code (0xFF)
            while (offset < 12) {
                if offset != 0{
                    let bufferTemp = file.readData(ofLength: 12 - offset)
                    if printBuffer(buffer: bufferTemp, tag: "bufferTemp") || printBuffer(buffer: buffer, tag: "buffer") {
                        print("stop")
                    }
                    
                    buffer.replaceSubrange(offset ... buffer.count-1, with: bufferTemp)
                    if printBuffer(buffer: buffer, tag: "buffer after replace"){
                        print("stop")
                    }
                    offset = buffer.count
                }else {
                    buffer = file.readData(ofLength: 12)
                    offset = buffer.count
                    if printBuffer(buffer: buffer, tag: "normal buffer") {
                        print("stop")
                    }
                }
                
            }
            var bufferOffset : Int = 0;
            while (bufferOffset < 12 && buffer[bufferOffset].hashValue != -1){
                bufferOffset += 1;
            }
            
            if (bufferOffset > 0) {
                if(bufferOffset != 12){
                    // print(bufferOffset)
                }
                // We didn't find a sync code (0xFF) at position 0;
                // shift the buffer over and try again
                var i : Int = 0;
                if bufferOffset == 11 {
                    print(bufferOffset)
                }
                while i < (12 - bufferOffset) {
                    buffer[i] = buffer[bufferOffset + i]
                    i+=1
                }
                //                for i in 0...12 - bufferOffset{
                //                    buffer[i] = buffer[bufferOffset + i]
                //                }
                pos += bufferOffset;
                offset = 12 - bufferOffset;
                continue;
            }
            
            // Check for MPEG 1 Layer III or MPEG 2 Layer III codes
            var mpgVersion : Int = 0;
            if (buffer[1].hashValue == -6 || buffer[1].hashValue == -5) {
                mpgVersion = 1;
            } else if (buffer[1].hashValue == -14 || buffer[1].hashValue == -13) {
                mpgVersion = 2;
            } else {
                bufferOffset = 1;
                var i : Int = 0
                while i < (12 - bufferOffset) {
                    buffer[i] = buffer[bufferOffset + i]
                    i += 1
                }
                //                for  i in 0...12 - bufferOffset{
                //                     buffer[i] = buffer[bufferOffset + i]
                //                }
                pos += bufferOffset;
                offset = 12 - bufferOffset;
                continue;
            }
            
            // The third byte has the bitrate and samplerate
            var bitRate : Int
            var sampleRate : Int
            if (mpgVersion == 1) {
                // MPEG 1 Layer III
                
                bitRate = BITRATES_MPEG1_L3[Int((buffer[2] & 0xF0) >> 4)]
                sampleRate = SAMPLERATES_MPEG1_L3[Int((buffer[2] & 0x0C) >> 2)]
            } else {
                // MPEG 2 Layer III
                bitRate = BITRATES_MPEG2_L3[Int((buffer[2] & 0xF0) >> 4)]
                sampleRate = SAMPLERATES_MPEG2_L3[Int((buffer[2] & 0x0C) >> 2)]
            }
            
            if (bitRate == 0 || sampleRate == 0) {
                bufferOffset = 2;
                var i : Int = 0
                while i < (12 - bufferOffset) {
                    buffer[i] = buffer[bufferOffset + i];
                    i+=1
                }
                //                for  i in 0 ... (12 - bufferOffset){
                //                    buffer[i] = buffer[bufferOffset + i];
                //                }
                pos += bufferOffset;
                offset = 12 - bufferOffset;
                continue;
            }
            
            // From here on we assume the frame is good
            mGlobalSampleRate = sampleRate;
            let padding : Int = Int((buffer[2] & 2) >> 1)
            let frameLen : Int = 144 * bitRate * 1000 / sampleRate + padding
            
            var gain : Int
            if ((buffer[3] & 0xC0) == 0xC0) {
                // 1 channel
                mGlobalChannels = 1;
                if (mpgVersion == 1) {
                    //TODO : chek it out
                    gain = Int((buffer[10] & 0x01) << 7) + Int((buffer[11] & 0xFE) >> 1)
                } else {
                    //TODO : chek it out
                    gain = Int((buffer[9] & 0x03) << 6) + Int((buffer[10] & 0xFC) >> 2);
                }
            } else {
                // 2 channels
                mGlobalChannels = 2;
                if (mpgVersion == 1) {
                    //TODO : chek it out
                    gain = Int((buffer[9]  & 0x7F) << 1) + Int((buffer[10] & 0x80) >> 7);
                } else {
                    gain = 0;  // ???
                }
            }
            
            mBitrateSum += bitRate
            
            mFrameGains[mNumFrames] = gain
            if gain < mMinGain {
                mMinGain = gain
            }
            if  gain > mMaxGain {
                mMaxGain = gain
            }
            
            mNumFrames+=1;
            if (mNumFrames == mMaxFrames) {
                // We need to grow our arrays.  Rather than naively
                // doubling the array each time, we estimate the exact
                // number of frames we need and add 10% padding.  In
                // practice this seems to work quite well, only one
                // resize is ever needed, however to avoid pathological
                // cases we make sure to always double the size at a minimum.
                
                mAvgBitRate = mBitrateSum / mNumFrames;
                let totalFramesGuess : Int = ((mFileSize / mAvgBitRate) * sampleRate) / 144000
                var newMaxFrames : Int = totalFramesGuess * 11 / 10
                if newMaxFrames < mMaxFrames * 2{
                    newMaxFrames = mMaxFrames * 2
                }
                //TODO : error
                var newGains = [Int]()
                newGains = Array(repeatElement(0, count: newMaxFrames))
                var i : Int = 0
                while i < mNumFrames{
                    newGains[i] = mFrameGains[i]
                    i+=1
                }
                //                for  i in 0 ... mNumFrames {
                //                    newGains[i] = mFrameGains[i]
                //                }
                mFrameGains = newGains
                mMaxFrames = newMaxFrames
            }
            //TODO : skip byte stream.skip(frameLen - 12);
            file.readData(ofLength: frameLen - 12)
            pos += frameLen;
            offset = 0;
        }
        
        // We're done reading the file, do some postprocessing
        if mNumFrames > 0{
            mAvgBitRate = mBitrateSum / mNumFrames
        }else{
            mAvgBitRate = 0
        }
        print(getAvgBitrateKbps(),getChannels(),getFileSizeBytes(),getFrameGains().count,getNumFrames(),getSampleRate(),getSamplesPerFrame())
        
    }
    
    func printBuffer(buffer : Data,tag : String) -> Bool{
        var signedByteArray = [Int8]()
        var signedByteArrayDebug = [Int8]()
        signedByteArrayDebug = [-1, -5, -110, -124, -25, 0, 2, -44, 126, -49, 3, -118]
        signedByteArray = buffer.map { Int8(bitPattern: $0) } // [Int8]
        if signedByteArray.elementsEqual(signedByteArrayDebug){
            return false
        }
        // print("\(tag) :  \(signedByteArray)")
        return false
    }
    
    let BITRATES_MPEG1_L3 : [Int] = [
        0,  32,  40,  48,  56,  64,  80,  96,
        112, 128, 160, 192, 224, 256, 320,  0 ];
    let BITRATES_MPEG2_L3 : [Int] = [
        0,   8,  16,  24,  32,  40,  48,  56,
        64,  80,  96, 112, 128, 144, 160, 0 ];
    let SAMPLERATES_MPEG1_L3 :[Int] = [
        44100, 48000, 32000, 0 ];
    let SAMPLERATES_MPEG2_L3 : [Int] = [
        22050, 24000, 16000, 0 ];
    
    
}

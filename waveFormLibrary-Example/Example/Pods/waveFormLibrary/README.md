# Mp3WaveForm-Swift3
![untitled](https://media.giphy.com/media/11Y9Ov7hwuplQY/giphy.gif)

# What's feature?
- draw waveform of mp3 file on screen
- draw line of playing position
- zoom-in and zoom-out waveform while playing
- use swift 3 version
# How to use?

- create ControllerWaveForm view, provide frame and mp3 URL and then add to your view holder

```swift
        let mp3File = Bundle.main.path(forResource: "02", ofType: "mp3")
        let url = URL(fileURLWithPath: mp3File!)
        let waveFormFrame = CGRect(x: 0, y: view.frame.height*1/3, width: view.frame.width, height: view.frame.height*2/3)
        let controllerWaveForm = ControllerWaveForm(frame: waveFormFrame, mp3Url: url)
        view.addSubview(controllerWaveForm)
```
# waveFormLibrary

# waveFormLibrary
![untitled](https://media.giphy.com/media/11Y9Ov7hwuplQY/giphy.gif)

# What's feature?
- draw waveform of mp3 file on screen
- draw current play position
- zoom-in and zoom-out waveform while playing
- use swift 3 version
# How to use?

- Install library : add pod 'waveFormLibrary', '~> 1.0' similar to the following to your Podfile:
```
target 'MyApp' do
  pod 'waveFormLibrary', '~> 1.0'
end
```
Then run a pod install inside your terminal, or from CocoaPods.app.

- Use storyboard 

 -The first : add a UIView(which you want to hold waveform view) to your view, in ```identity inspector``` change custom class to ```ControllerWaveForm``` class. 
 
![untitled](https://cloud.githubusercontent.com/assets/8258900/24530426/09b3681e-15dc-11e7-86e9-779083796318.png
)

 -Now you can change waveform line color and current play position line color in ```attribute inspector```

![untitled](https://cloud.githubusercontent.com/assets/8258900/24530505/9e5b37f8-15dc-11e7-9cf4-cf1d118e78a8.png)

 -Connect your waveForm view to viewController
  ```swift
   @IBOutlet weak var controller: ControllerWaveForm!
   ```
   set mp3 url which you need draw waveform
   ```swift
   controller.setMp3Url(mp3Url: url)
   ```
  -In this example I create mp3 url by copy file 02.mp3 to my project and then add below code
   ```swift
   let mp3file = Bundle.main.path(forResource: "02", ofType: "mp3")
   let url = URL(fileURLWithPath: mp3file!)
   ```
   - Please email me thongds@gmail.com if you need help!

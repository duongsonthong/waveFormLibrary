//
//  ViewController.swift
//  Example
//
//  Created by SSd on 3/31/17.
//  Copyright © 2017 SSd. All rights reserved.
//

import UIKit
import waveFormLibrary
class ViewController: UIViewController {

    @IBOutlet weak var waveFormController: ControllerWaveForm!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mp3file = Bundle.main.path(forResource: "02", ofType: "mp3")
        let url = URL(fileURLWithPath: mp3file!)
        waveFormController.setMp3Url(mp3Url: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


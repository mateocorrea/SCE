//
//  Credits.swift
//  BuddyBotFinal
//
//  Created by Mateo Correa on 1/25/16.
//  Copyright © 2016 Mateo Correa. All rights reserved.
//

import UIKit

class Credits: UIViewController {
    
    var currentBotImage = 1;
    var waveTimer = NSTimer()
    @IBOutlet weak var botBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor.blackColor()
        waveTimer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: Selector("wave"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wave() {
        currentBotImage = (currentBotImage == 1) ? 2 : 1
        
        if let image = UIImage(named: ("BuddyBotCredits" + String(currentBotImage) + ".png")) {
            //sender.setImage(image, forState: .Normal)
            botBut.setImage(image, forState: .Normal)
        }
        
    }
}




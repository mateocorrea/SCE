//
//  StartScreen.swift
//  BuddyBotFinal
//
//  Created by Mateo Correa on 1/25/16.
//  Copyright © 2016 Mateo Correa. All rights reserved.
//

import UIKit

var currentBotImage = 0;

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class StartScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor.cyanColor()
        self.view.backgroundColor = UIColor(red: 0x1A, green: 0xF1, blue: 0xFF)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func botPressed(sender: UIButton) {
        var newImage = Int(arc4random_uniform(UInt32(8)))
        while(newImage == currentBotImage) {
            newImage = Int(arc4random_uniform(UInt32(8)))
        }
        var imageName = ""
        if(newImage == 0) {
            imageName = "LDD"
        } else if(newImage == 1) {
            imageName = "LDU"
        } else if(newImage == 2) {
            imageName = "LUD"
        } else if(newImage == 3) {
            imageName = "LUU"
        } else if(newImage == 4) {
            imageName = "RDD"
        } else if(newImage == 5) {
            imageName = "RDU"
        } else if(newImage == 6) {
            imageName = "RUD"
        } else { //(newImage == 7) {
            imageName = "RUU"
        }
        if let image = UIImage(named: ("BuddyBot" + imageName + ".png")) {
            sender.setImage(image, forState: .Normal)
        }
        
        currentBotImage = newImage
        //sender.setImage(coin,forState: UIControlState.Highlighted);
    }
    /*
    
    if let image = UIImage(named: "play.png") {
        playButton.setImage(image, forState: .Normal)
    }*/
}


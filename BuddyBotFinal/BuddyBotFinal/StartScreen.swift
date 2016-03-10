//
//  StartScreen.swift
//  BuddyBotFinal
//
//  Created by Mateo Correa on 1/25/16.
//  Copyright © 2016 Mateo Correa. All rights reserved.
//

import UIKit
import AVFoundation

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
    var backgroundMusic : AVAudioPlayer?
    var mainTimer = NSTimer()
    
    @IBOutlet weak var botBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor.cyanColor()
        self.view.backgroundColor = UIColor(red: 0x1A, green: 0xF1, blue: 0xFF)
        
        setupBackgroundMusic()
        
        mainTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    @IBAction func botPressed(sender: UIButton) {
        NSLog("running")
        changeBotImage()
        
    }
    
    func setupBackgroundMusic() {
        let song = Int(arc4random_uniform(UInt32(5)))
        var songName = ""
        if(song == 0) {
            songName = "Happy Days"
        } else if(song == 1) {
            songName = "Gone Fishin'"
        } else if(song == 2) {
            songName = "Eyeliner"
        } else if(song == 3) {
            songName = "Sweet Success"
        } else if(song == 4) {
            songName = "Feelin Good"
        }
        if let backgroundMusic = self.setupAudioPlayerWithFile(songName, type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
        
        backgroundMusic?.volume = 0.3
        //backgroundMusic?.play()
    }
    
    func update() {
        changeBotImage()
        if backgroundMusic?.playing == false {
            setupBackgroundMusic()
        }
    }
    
    func changeBotImage() {
        var newImage = Int(arc4random_uniform(UInt32(24)))
        while(newImage == currentBotImage) {
            newImage = Int(arc4random_uniform(UInt32(24)))
        }
        var imageName = ""
        if(newImage == 0) {
            imageName = "LDDSA"
        } else if(newImage == 1) {
            imageName = "LDDSA"
        } else if(newImage == 2) {
            imageName = "LDDAS"
        } else if(newImage == 3) {
            imageName = "LDUSS"
        } else if(newImage == 4) {
            imageName = "LDUSA"
        } else if(newImage == 5) {
            imageName = "LDUAS"
        } else if(newImage == 6) {
            imageName = "LUDSS"
        } else if(newImage == 7) {
            imageName = "LUDSA"
        } else if(newImage == 8) {
            imageName = "LUDAS"
        } else if(newImage == 9) {
            imageName = "LUUSS"
        } else if(newImage == 10) {
            imageName = "LUUSA"
        } else if(newImage == 11) {
            imageName = "LUUAS"
        } else if(newImage == 12) {
            imageName = "RDDSS"
        } else if(newImage == 13) {
            imageName = "RDDSA"
        } else if(newImage == 14) {
            imageName = "RDDAS"
        } else if(newImage == 15) {
            imageName = "RDUSS"
        } else if(newImage == 16) {
            imageName = "RDUSA"
        } else if(newImage == 17) {
            imageName = "RDUAS"
        } else if(newImage == 18) {
            imageName = "RUDSS"
        } else if(newImage == 19) {
            imageName = "RUDSA"
        } else if(newImage == 20) {
            imageName = "RUDAS"
        } else if(newImage == 21) {
            imageName = "RUUSS"
        } else if(newImage == 22) {
            imageName = "RUUSA"
        } else { //(newImage == 23) {
            imageName = "RUUAS"
        }
        if let image = UIImage(named: (imageName + ".png")) {
            //sender.setImage(image, forState: .Normal)
            botBut.setImage(image, forState: .Normal)
        }
        
        currentBotImage = newImage
        //sender.setImage(coin,forState: UIControlState.Highlighted);
    }
    
    
    /*
    
    if let image = UIImage(named: "play.png") {
        playButton.setImage(image, forState: .Normal)
    }*/
}


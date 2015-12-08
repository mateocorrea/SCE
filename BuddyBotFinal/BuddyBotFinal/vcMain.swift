//
//  vcMain.swift
//  BuddyBotFinal
//
//  Created by Mateo Correa on 12/1/15.
//  Copyright © 2015 Mateo Correa. All rights reserved.
//

import UIKit
import CoreData

class vcMain: UIViewController {
    
    var trainingMode = true;
    
    @IBOutlet var messageField: UITextField!
    @IBOutlet var responseLabel: UILabel!
    
    var phrases = [NSManagedObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Phrase")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            phrases = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSend() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate .managedObjectContext
        let entity = NSEntityDescription.entityForName("Phrase", inManagedObjectContext: managedContext)
        
        var currentMessageKey: String! = ""
        
        if(trainingMode) {
            
            var messageExists = false
            var responseExists = false
            
            /* Seperate the training message into the message and the response */
            let fullText: String! = messageField.text
            let convoArr = fullText.componentsSeparatedByString("QQQ")
            let messageText = convoArr[0]
            let responseText = convoArr[1]
            
            for phrase in phrases {
                // if message exists
                if messageText == (phrase.valueForKey("content") as! String) {
                    
                    messageExists = true
                    currentMessageKey = (phrase.valueForKey("mesKey") as! String)
                    
                }
            }
            for phrase in phrases {
                if responseText == (phrase.valueForKey("content") as! String) { // if response exists
                    
                    responseExists = true
                    
                    for var index = 1; index < 26; index++ {
                        print(currentMessageKey)
                        if (phrase.valueForKey("resKey" + String(index)) as? String) == currentMessageKey {
                            break // if already connected, break
                        }
                        if phrase.valueForKey("resKey" + String(index)) == nil {
                            phrase.setValue(currentMessageKey, forKey: "resKey" + String(index))
                            break
                        }
                    }
                }
            }
            
            
            if(!messageExists) {
                let message = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                message.setValue(messageText, forKey: "content")
                message.setValue(String(phrases.count + 1), forKey: "mesKey")
                currentMessageKey = String(phrases.count + 1)
        
                do {
                    try managedContext.save()
                    phrases.append(message)
                } catch let error as NSError {
                    print("Message could not save \(error), \(error.userInfo)")
                }
            }
            if(!responseExists) {
                let response = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                response.setValue(responseText, forKey: "content")
                response.setValue(String(phrases.count + 1), forKey: "mesKey")
                response.setValue(currentMessageKey, forKey: "resKey1")
                
                do {
                    try managedContext.save()
                    phrases.append(response)
                } catch let error as NSError {
                    print("Response could not save \(error), \(error.userInfo)")
                }
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError { //dskfjads;k fjasdk;fadskfas
                
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } else {
            
            let messageText = messageField.text
            
            for phrase in phrases {
                if messageText == (phrase.valueForKey("content") as! String) {
                    currentMessageKey = (phrase.valueForKey("mesKey") as! String)
                }
            }
            
            var allResponses = [String]()
            for phrase in phrases {
                for var index = 1; index < 26; index++ {
                    if currentMessageKey == (phrase.valueForKey("resKey" + String(index))) as? String {
                        allResponses.append(phrase.valueForKey("content") as! String)
                    }
                }
            }
            
            let randInt = Int(arc4random_uniform(UInt32(allResponses.count)))
            
            responseLabel.text = allResponses[randInt]
        }
    }
    
    @IBAction func btnLoad() {
        for p in phrases {
            print("Content: \(p.valueForKey("content")!) // MessageKey: \(p.valueForKey("mesKey")!) // ResponseKey1: \(p.valueForKey("resKey1")) // ResponseKey2: \(p.valueForKey("resKey2"))")
        }
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    
    
    */
    
    func connect(res: NSManagedObject, key: String?) {
    }
    
    
    
}

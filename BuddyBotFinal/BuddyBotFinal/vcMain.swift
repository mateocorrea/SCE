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
    
    var trainingMode = false;
    
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
        
        
        
        var messageExists = false
        var responseExists = false
        
        if(trainingMode) {
            var currentMessageKey: String! = ""
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
            //currently:
            // 1. looks for the message, gets its key
            // 2. if key not found, then sets it to 1
            // 3. adds all the messages that have that key to an array
            // 4. responds with a random message from the array
            
            // what should happen:
            // 1. Looks for the most similar phrase to the user's message (or one that meets a certain similarity requirement)
            // --needs to save the uer's message as a new phrase (if it does not already exist) and set it as a response to the computer's message
            // --if the user's phrase already exists, then it needs to be connected to the  ocmputers's message if it is not already
            // 2. get the key
            // 3. add all the messages that have that key to an array
            // 4. respond with a random message from the array
            
            
            
            // checking for similarity:
            // caps dont matter, punctuation doesn't matter,
            
            
            let messageText = messageField.text
            var message: NSManagedObject?
            let computerMessage = responseLabel.text
            var computerMessageKey = ""
            
            
            /* NEEDS TO LOOK FOR A SIMILAR PHRASE AND GET ITS KEY, NOT AN EXACT PHRASE */
            for phrase in phrases {
                if messageText == (phrase.valueForKey("content") as! String) { // needs to look for similarity, not exactness
                    message = phrase
                    messageExists = true
                    break
                }
            }
            if message == nil { // get rid of this, when checking for similarity works
                message = phrases[0]
            }
            
            /* get the mesKey of the computerMessage */
            for phrase in phrases {
                if computerMessage == (phrase.valueForKey("content") as! String) {
                    computerMessageKey = phrase.valueForKey("mesKey") as! String
                }
            }
            
            /* create a new message if the message did not exist */
            if(!messageExists) {
                let newMessage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                newMessage.setValue(messageText, forKey: "content")
                newMessage.setValue(String(phrases.count + 1), forKey: "mesKey")
                newMessage.setValue(computerMessageKey, forKey: "resKey1") // saves it as a response for the computer's message
                
                do {
                    try managedContext.save()
                    phrases.append(newMessage)
                } catch let error as NSError {
                    print("Message could not save \(error), \(error.userInfo)")
                }
            } else { // message already exists, connect it to the computer message
                for var index = 1; index < 26; index++ {
                    if (message!.valueForKey("resKey" + String(index)) as? String) == computerMessageKey {
                        break // if already connected, break
                    }
                    if message!.valueForKey("resKey" + String(index)) == nil {
                        message!.setValue(computerMessageKey, forKey: "resKey" + String(index))
                        break // break after connecting
                    }
                }
            }
            
            /* responds to the most similar message in the database, regardless of what the user said */
            var allResponses = [String]()
            for phrase in phrases {
                for var index = 1; index < 26; index++ {
                    if message!.valueForKey("mesKey") as? String == (phrase.valueForKey("resKey" + String(index))) as? String {
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

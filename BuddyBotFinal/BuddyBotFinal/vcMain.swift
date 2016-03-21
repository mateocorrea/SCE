//
//  vcMain.swift
//  BuddyBotFinal
//
//  Created by Mateo Correa on 12/1/15.
//  Copyright © 2015 Mateo Correa. All rights reserved.
//

import UIKit
import CoreData

class vcMain: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    var coderMode = true;
    
    var trainingMode = false;
    var convoArray:[String] = [String]()
    
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
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
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set self as the delegate for the textfield
        self.messageField.delegate = self
        
        // Add a tap gesture recognizer to the tableview
        let tapGesture = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        //self.view.backgroundColor = UIColor.greenColor()
        
        /* FIX FIX FIX */
        var next = ""
        if responseLabel.text == "Label" {
            repeat {
                let randInt = Int(arc4random_uniform(UInt32(preRecordedConvos.count)))
                responseLabel.text = preRecordedConvos[randInt]
                
                next = preRecordedConvos[randInt+1]
            } while (["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*"].contains(Array(responseLabel.text!.characters)[0]) || Array(next.characters)[0] != "*")
            
            self.convoArray.append("*@$" + responseLabel.text!)
        }
        
        
        self.messageTableView.estimatedRowHeight = 80
        self.messageTableView.rowHeight = UITableViewAutomaticDimension
        self.messageTableView.separatorColor = UIColor.whiteColor()
        
        self.messageTableView.setNeedsLayout()
        self.messageTableView.layoutIfNeeded()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableViewTapped() {
        // Force the textfield to end editing
        self.messageField.endEditing(true)
    }
    
    // MARK: Textfield Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Perform an animation to grow the dockview
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            
            self.dockViewHeightConstraint.constant = 315
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        // Perform an animation to shrink the dockview
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return convoArray.count
    }
    
    // MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier: String
        var text: String
        var x = Array(self.convoArray[indexPath.section].characters)
        if (x[0] == "*") && (x[1] == "@") && (x[2] == "$") {
            identifier = "BotMessageCell"
            let index = self.convoArray[indexPath.row].startIndex
            text = self.convoArray[indexPath.section].substringFromIndex(index.advancedBy(3))
        } else {
            identifier = "UserMessageCell"
            text = self.convoArray[indexPath.section]
        }
        
        // Create a table cell
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        
        // Customize the cell
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.textColor = UIColor.whiteColor()
        if(identifier == "BotMessageCell") {
            //cell.textLabel?.textColor = UIColor.whiteColor()
        } else {
            //cell.textLabel?.textColor = UIColor.greenColor()
            cell.textLabel?.textAlignment = NSTextAlignment.Right
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        
        // Return the cell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//convoArray.count
    }
    
    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "//sections[section].heading
    }*/
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView()
        returnedView.backgroundColor = UIColor.clearColor()
        
        let label = UILabel()
        label.text = " "
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    /*
    * Plan of Action
    * 1. Save Computers message in a variable
    * 2. Save User's Un-edited Message in a variable
    * 3. Check if message is in database
    * 4A. If so: set as response to computer message. Set as the respondable message (must have responses)
    * 4B. If not in database, save in database. Set as response to computer message. Look for similar message to be the respondable one (must have responses)
    * 5. Select a response to the respondable message, save that as the computer message, but present a version with more emotion
    */
    @IBAction func btnSend() {
        
        // Call the end editing method for the text field
        self.messageField.endEditing(true)
        
        /* FIX needs to be done in an init */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate .managedObjectContext
        let entity = NSEntityDescription.entityForName("Phrase", inManagedObjectContext: managedContext)
        if(phrases.count == 0) {
            preTrain(entity!, managedContext: managedContext)
            NSLog("pretrained")
        }
        
        // STEP 1
        var computerMessageText = responseLabel.text
        print("computer message text is \(computerMessageText)")
        if(computerMessageText == nil) {
            computerMessageText = preRecordedConvos[0]
        }
        var computerMessage: NSManagedObject?
        for p in phrases {
            if (p.valueForKey("content") as! String) == computerMessageText {
                computerMessage = p
                break
            }
        }
        
        // STEP 2
        let messageText = messageField.text
        
        
        // STEP 3
        var userMessage: NSManagedObject?
        var messageExists = false
        for p in phrases {
            if (p.valueForKey("content") as! String) == messageText {
                messageExists = true
                userMessage = p
                break
            }
        }
        
        
        // STEP 4A
        var messageToBeAnswered: NSManagedObject?
        if messageExists {
            //set as response to computer message. Set as the respondable message (must have responses)
            for var index = 1; index < 26; index++ {
                if computerMessage!.valueForKey("resKey" + String(index)) == nil {
                    computerMessage!.setValue(userMessage!.valueForKey("mesKey"), forKey: "resKey" + String(index))
                    break
                }
            }
            do {
                try managedContext.save()
                print("The user's message was already in the database but was now saved as a response to the computer's original message")
            } catch let error as NSError {
                print("Message could not save \(error), \(error.userInfo)")
            }
        } else { // STEP 4B
            //If not in database, save in database. Set as response to computer message. Look for similar message to be the respondable one (must have responses)
            let newMessage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            newMessage.setValue(messageText, forKey: "content")
            newMessage.setValue(String(phrases.count + 1), forKey: "mesKey")
            for var index = 1; index < 26; index++ {
                if computerMessage!.valueForKey("resKey" + String(index)) == nil {
                    computerMessage!.setValue(newMessage.valueForKey("mesKey"), forKey: "resKey" + String(index))
                    break
                }
            }
            do {
                try managedContext.save()
                phrases.append(newMessage)
                print("The user's message was added to the database and saved as a response to the computer's original message")
            } catch let error as NSError {
                print("Message could not save \(error), \(error.userInfo)")
            }
        }
        if messageExists {
            if userMessage!.valueForKey("resKey1") != nil {
                messageToBeAnswered = userMessage!
            } else {
                messageToBeAnswered = respondableMessage(messageText!)
            }
        } else {
            messageToBeAnswered = respondableMessage(messageText!)
        }
        
        self.convoArray.append(messageText!)
        
        
        
        print("The exact message sent: \(messageText)")
        print("The message being replied to: \(messageToBeAnswered!.valueForKey("content") as! String) (Has mesKey of \(messageToBeAnswered!.valueForKey("mesKey") as! String))")
        print("The computer's original message's mesKey: \(computerMessage!.valueForKey("mesKey"))")
        
        /* responds to the most similar message in the database, regardless of what the user said */
        var allResponses = answersTo(messageToBeAnswered!)
        
        let randInt = Int(arc4random_uniform(UInt32(allResponses.count)))
        print(allResponses)
        responseLabel.text = allResponses[randInt] // fails when nothing is a response
        self.convoArray.append("*@$" + responseLabel.text!)
        messageField.text = ""
        
        self.messageTableView.reloadData()
    }
    
    
    
    @IBAction func btnLoad() {
        exportDataBase()
        
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
    
    // FIX
    func preTrain(entity: NSEntityDescription, managedContext: NSManagedObjectContext) {
        
        /*for var i = 0; i < preRecordedConvos.count; i = i + 2 {
            let message = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
            message.setValue(preRecordedConvos[i], forKey: "content")
            message.setValue(String(phrases.count + 1), forKey: "mesKey")
            let response = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
            response.setValue(preRecordedConvos[i+1], forKey: "content")
            response.setValue(String(phrases.count + 2), forKey: "mesKey")
            
            message.setValue(response.valueForKey("mesKey") as! String, forKey: "resKey1")
            do {
                try managedContext.save()
                phrases.append(message)
                phrases.append(response)
            } catch let error as NSError {
                print("Message could not save \(error), \(error.userInfo)")
            }
        }*/
        var start = 2
        var end = 3
        while start < preRecordedConvos.count { //something
            var keys = [String]()
            for var i = start; i < preRecordedConvos.count; i++ {
                let string = preRecordedConvos[i]
                let chars = Array(string.characters)
                if((chars[0] == "*") && (chars[1] == "*") && (chars[chars.count-2] == "*") && (chars[chars.count-1] == "*")) {
                    end = i // end is index of next numbering
                    break
                } else {
                    keys.append(string)
                }
            }
            
            let message = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
            message.setValue(preRecordedConvos[start-1], forKey: "content")
            message.setValue(String(phrases.count + 1), forKey: "mesKey")
            
            var keyCount = 0
            for k in keys {
                keyCount++
                message.setValue(k, forKey: ("resKey" + String(keyCount)))
            }
            do {
                try managedContext.save()
                phrases.append(message)
            } catch let error as NSError {
                print("Message could not save \(error), \(error.userInfo)")
            }
            start = end + 2
        }
    }
    
    func levenshteinDistance(s: String, t: String) -> Int
    {
        // degenerate cases
        if s == t { return 0 }
        if s.characters.count == 0 { return t.characters.count }
        if t.characters.count == 0 { return s.characters.count }
        // create two work vectors of integer distances
        var v0 = [Int?](count: t.characters.count+1, repeatedValue: nil)
        var v1 = [Int?](count: t.characters.count+1, repeatedValue: nil)
        //int[] v0 = new int[t.Length + 1];
        //int[] v1 = new int[t.Length + 1];
        // initialize v0 (the previous row of distances)
        // this row is A[0][i]: edit distance for an empty s
        // the distance is just the number of characters to delete from t
        for var i = 0; i < v0.count; i++ {
            v0[i] = i;
        }
        for var i = 0; i < s.characters.count; i++ {
            // calculate v1 (current row distances) from the previous row v0
    
            // first element of v1 is A[i+1][0]
            //   edit distance is delete (i+1) chars from s to match empty t
            v1[0] = i + 1;
    
            // use formula to fill in the rest of the row
            for var j = 0; j < t.characters.count; j++ {
                var cost = 1
                
                /*var text = "Hello World"
                let firstChar = text[text.startIndex.advancedBy(0)]*/
                
                
                if s[s.startIndex.advancedBy(i)] == t[t.startIndex.advancedBy(j)] {
                    cost = 0
                }
                
                /*if s[i] == t[j] {
                    cost = 0
                }*/
                let x = v1[j]! + 1
                let y = v0[j + 1]! + 1
                let z = v0[j]! + cost
                
                var smallest = x
                if y < smallest {
                    smallest = y
                }
                if z < smallest {
                    smallest = z
                }
                
                v1[j + 1] = smallest
            }
            // copy v1 (current row) to v0 (previous row) for next iteration
            for var j = 0; j < v0.count; j++ {
                v0[j] = v1[j];
            }
        }
        return v1[t.characters.count]!;
    }
    
    
    func respondableMessage(text: String) -> NSManagedObject
    {
        var message: NSManagedObject?
        var minSimilarity = 100000
        for phrase in filteredByWordCount(phrases, wordCnt: wordCount(text)) {
            if hasAnswers(phrase) {
                let s = similarity(text, b: phrase.valueForKey("content") as! String)
                if  (s < minSimilarity) && ((phrase.valueForKey("mesKey") as? String)?.characters.count > 0) {
                    message = phrase
                    minSimilarity = s
                    if s == 0 {
                        break
                    }
                }
            }
            
        }
        if message == nil {
            return phrases[0] // FIX
        }
        return message!
    }
    
    
    func similarity(a: String, b: String) -> Int {
        
        let aString = simplifyString(a)
        let bString = simplifyString(b)
        //print(aString)
        //print(bString)
        return levenshteinDistance(aString, t: bString)
    }
    
    /* FIX -->, remove punctuation, */
    func simplifyString(str: String) -> String {
        var s = str.lowercaseString
        
        let useless_words = ["and", "is", "the", "a", "an", "of"]
        for word in useless_words {
            s = s.stringByReplacingOccurrencesOfString(" \(word) ", withString: " ")
        }
        
        let punctuation = ["?", "'"]
        for char in punctuation {
            s = s.stringByReplacingOccurrencesOfString(char, withString: "")
        }
        
        let replacements = ["your", "ur", "you", "u", "favorite", "fav"]
        
        for var i = 0; i < replacements.count; i = i+2 {
            s = s.stringByReplacingOccurrencesOfString(replacements[i], withString: replacements[i+1])
        }
        
        return s
    }
    

    func answersTo(message: NSManagedObject) -> [String] {
        var numbers = [String]()
        for var index = 1; index < 26; index++ {
            if message.valueForKey("resKey" + String(index)) == nil {
                break
            } else {
                numbers.append(message.valueForKey("resKey" + String(index)) as! String)
            }
        }
        
        var responses = [String]()
        for p in phrases {
            if numbers.contains(p.valueForKey("mesKey") as! String) {
                responses.append(p.valueForKey("content") as! String)
            }
        }
        return responses
    }
    func responseKeysFor(message: NSManagedObject) -> [String] {
        var numbers = [String]()
        for var index = 1; index < 26; index++ {
            if message.valueForKey("resKey" + String(index)) == nil {
                break
            } else {
                numbers.append(message.valueForKey("resKey" + String(index)) as! String)
            }
        }
        return numbers
    }
    
    func hasAnswers(message: NSManagedObject) -> Bool {
        if message.valueForKey("resKey1") != nil {
            return true
        }
        return false
    }
    
    //fix
    func exportDataBase()
    {
        NSLog("running export database")
        print("var preRecordedConvos = [")
        var x = 0
        /*for p in phrases {
            x++
            print("\"**" + String(x) + "**\",")
            print("Content: \(p.valueForKey("content")!) // MessageKey: \(p.valueForKey("mesKey")!) // ResponseKey1: \(p.valueForKey("resKey1")) // ResponseKey2: \(p.valueForKey("resKey2"))")
        }*/
        for p in phrases {
            x++
            print("\"**" + String(x) + "**\",")
            print("\"\(p.valueForKey("content")!)\",")
            for x in responseKeysFor(p) {
                print("\"" + x + "\",")
            }
            
        }
        // MUST GET RID OF LAST COMMA
        print("]")
    }
    
    
    
    
    /*******************************/
     /* Goes from half of length to 1.5 times the length */
    func filteredByLength(array: [NSManagedObject], filterLength: Int) -> [NSManagedObject]
    {
        print("original array: \(array.count)")
        
        // Filter by length of string
        let minLength = filterLength / 2
        let maxLength = (filterLength * 3) / 2
        var newArray = [NSManagedObject]()
        for thing in array {
            let length = (thing.valueForKey("content") as! String).characters.count
            if (minLength <= length) && (length <= maxLength) {
                newArray.append(thing)
            }
        }
        print("new filtered array: \(newArray.count)")
        return newArray
    }
    
    func filteredByWordCount(array: [NSManagedObject], wordCnt: Int) -> [NSManagedObject]
    {
        print("original array: \(array.count)")
        var change = 0
        if wordCnt < 2 {
            change = 0
        } else {
            change = Int(round(1.1146 * pow(Double(wordCnt), -0.4727)))
        }
        let minLength = wordCnt - change
        let maxLength = wordCnt + change
        
        var newArray = [NSManagedObject]()
        for thing in array {
            let length = wordCount(thing.valueForKey("content") as! String)
            if (minLength <= length) && (length <= maxLength) {
                newArray.append(thing)
            }
        }
        print("new filtered array: \(newArray.count)")
        return newArray
    }
    
    func wordCount(word: String) -> Int
    {
        return word.componentsSeparatedByString(" ").count - 1
    }
}

//
//  ViewController.swift
//  AppleTest
//
//  Created by Srikanth Adavalli on 7/23/16.
//  Copyright © 2016 Srikanth Adavalli. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    var textString: NSManagedObject!
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    
    var sampleString = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.autocorrectionType = .No
        textView.sizeToFit()
        textView.scrollEnabled = true
        textField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        fetchPapers()
    }
    
    
    //-- fetch data from CoreData --//
    func fetchPapers () {
        
        //-- CoreData starts --//
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "SampleString")
        
        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetchRequest)
            sampleString = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //-- CoreData ends --//
        
        var textToDisplay = ""
        
        for paper in sampleString {
            textToDisplay = paper.valueForKey("textField") as! String
        }
        
        let replacedString = textToDisplay.stringByReplacingOccurrencesOfString("And ", withString: "@&$")
        let replacedString2 = replacedString.stringByReplacingOccurrencesOfString(" and ", withString: "@&$")
        
        textView.text = replacedString2
        textField.text = textToDisplay
        
    }
    
    //-- Save to CoreData --//
    func saveNote(myText:String){
        
        //-- Get a tray first --//
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("SampleString", inManagedObjectContext: managedObjectContext)
        let paper = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        //-- put food on tray --//
        paper.setValue(myText, forKey: "textField")
        
        do {
            try managedObjectContext.save()
            sampleString.append(paper)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        fetchPapers()
    }
    
    func textFieldDidChange(textField: UITextField) {
        textView.text = textField.text
        self.textField.text = textField.text
        saveNote(textField.text!)
    }
}

class SampleText: NSManagedObject {
    
    @NSManaged var textFieldText: String
    
}


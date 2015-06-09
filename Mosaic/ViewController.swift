//
//  ViewController.swift
//  Mosaic
//
//  Created by Ali on 2015-05-25.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.setTitle("Test Button", forState: .Normal)
        
        self.view.addSubview(button)
        self.view.backgroundColor = UIColor.whiteColor()
        button.addTarget(self, action: "eventDetailsPush:", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func eventDetailsPush(sender: AnyObject) {
        let nextController = EventDetailsViewController(eventTitle: "HI")
        self.navigationController?.pushViewController(nextController, animated: true)
    }

}


//
//  AttendingControlloer.swift
//  Mosaic
//
//  Created by Renato Fernandes on 2015-06-11.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import Parse

class AttendingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        
        self.title = "Attending"
        //self.navigationItem.hidesBackButton = true
        
        // Top Bar with Menu and Settings
        var settings : UIBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        var menu : UIBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        self.navigationItem.leftBarButtonItem = menu
        self.navigationItem.rightBarButtonItem = settings
        
        //        //Bottom Bar Buttons
        //        var buttons:[UIButton] = []
        //
        //        var home = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        //        home.frame = CGRectMake(0, self.view.frame.size.height - 46, 100, 50)
        //        home.backgroundColor = UIColor.greenColor()
        //        home.setTitle("Home", forState: UIControlState.Normal)
        //
        //        buttons.append(home)
        //
        //
        //        let bottombar = UIToolbar()
        //        bottombar.frame = CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 46)
        //        bottombar.sizeToFit()
        //        //bottombar.setItems(buttons, animated: true)
        //        bottombar.backgroundColor = UIColor.whiteColor()
        //        self.view.addSubview(bottombar)
        
        
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
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
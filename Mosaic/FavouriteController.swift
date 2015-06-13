//
//  FavouriteController.swift
//  Mosaic
//
//  Created by Renato Fernandes on 2015-06-11.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import Parse

class FavouriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var events: [PFObject] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding events
        //        var event: Event = Event()
        //        event.title = "Google Info Session"
        //        event.fb_id = "125634fdvd"
        //        event.location = "Waterloo, Canada"
        //        event.weather = 99
        //        event.picture_url = "http://ancurlfjfdkjvndfjkv.com"
        //        event.details = "This is details"
        //        event.date = NSDate()
        //        event.saveInBackground()
        
        //        let tableView = UITableView()
        //        self.view.addSubview(tableView)
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        let eventObjectQuery = Favourite.query()
        
        
        eventObjectQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        var favourite = object as! Favourite
                        self.events.append(favourite.event)
                        
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        
        self.title = "Favourites"
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
        
        
        
        
        
        
        //        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        //        button.frame = CGRectMake(100, 100, 100, 50)
        //        button.setTitle("Test Button", forState: .Normal)
        //
        //        self.view.addSubview(button)
        //        self.view.backgroundColor = UIColor.whiteColor()
        //        button.addTarget(self, action: "eventDetailsPush:", forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.events.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var event: Event = self.events[indexPath.row] as! Event
        cell.textLabel?.text = event.title
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var event: Event = self.events[indexPath.row] as! Event
        let eventDetailsViewController = EventDetailsViewController(event: event)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}
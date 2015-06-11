//
//  ViewController.swift
//  Mosaic
//
//  Created by Ali on 2015-05-25.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        
        let eventObjectQuery = Event.query()
        
        eventObjectQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        self.events.append(object)
                        
                    }
                self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        
        
        
        

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


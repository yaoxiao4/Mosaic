//
//  AttendingControlloer.swift
//  Mosaic
//
//  Created by Renato Fernandes on 2015-06-11.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import Parse

class AttendingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var events: [PFObject] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"

        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        self.view.addSubview(tableView)
        
        
        let RSVPObjectQuery = RSVP.query()
        RSVPObjectQuery?.whereKey("status", equalTo: 1)
        
        PFUser.query()?.getObjectInBackgroundWithId("rdgLaK2buR"){
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                RSVPObjectQuery?.whereKey("user", equalTo: user!)
                RSVPObjectQuery?.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        println("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects as? [RSVP] {
                            for object in objects {
                                self.events.append(object.event)
                                
                            }
                            self.tableView.reloadData()
                        }
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                    }
                }

            } else {
                println(error)
            }
            
        }
        
        self.title = "Attending"
        //self.navigationItem.hidesBackButton = true
        
        // Top Bar with Menu and Settings
        var settings : UIBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        var menu : UIBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        self.navigationItem.leftBarButtonItem = menu
        self.navigationItem.rightBarButtonItem = settings
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: TableView methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell") as! EventTableViewCell
        var event: Event = self.events[indexPath.row] as! Event

        cell.configureCellWithEvent(event)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var event: Event = self.events[indexPath.row] as! Event
        let eventDetailsViewController = EventDetailsViewController(event: event)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
}
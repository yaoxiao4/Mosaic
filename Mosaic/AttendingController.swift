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
    var users: [PFUser] = []
    var favourites: [PFObject] = []
    var rsvp: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Attending"

        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        self.view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        fetch();
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
        var isFavourite = contains(self.favourites, event)
        let eventDetailsViewController = EventDetailsViewController(event: event, isFavourite: isFavourite, rsvp: 1)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func fetch(){
        self.events = []
        self.users = []
        self.favourites = []
        self.rsvp = []
        let userQuery = User.query()
        let RSVPObjectQuery = RSVP.query()
        RSVPObjectQuery?.whereKey("status", equalTo: 1)
        
        userQuery?.getObjectInBackgroundWithId("rdgLaK2buR"){
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                RSVPObjectQuery?.whereKey("user", equalTo: user!)
                RSVPObjectQuery?.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // Do something with the found objects
                        if let objects = objects as? [RSVP] {
                            for object in objects {
                                self.rsvp.append(object.event)
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
        
        User.query()?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        self.users.append(object)
                    }
                    
                    //Create Favourite Query Once we have queried all the users since
                    //Favourite Query is queried based on the current User
                    //REMOVE ONCE WE FIND A BETTER WAY TO FETCH CURRENT USER
                    
                    let favObjectQuery = Favourite.query()
                    favObjectQuery?.includeKey("location")
                    favObjectQuery?.orderByAscending("date")
                    favObjectQuery?.whereKey("isFavourite", equalTo: true)
                    favObjectQuery?.whereKey("user", equalTo: self.users[0])
                    
                    favObjectQuery?.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    var favourite = object as! Favourite
                                    self.favourites.append(favourite.event)
                                }
                            }
                        } else {
                            // Log details of the failure
                            println("Error: \(error!) \(error!.userInfo!)")
                        }
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    
    }
}
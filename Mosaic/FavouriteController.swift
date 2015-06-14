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
    var users: [PFUser] = []
    var favourites: [PFObject] = []
    let tableView = UITableView()
    var rsvp: [Event] = []
    var attending: [Event] = []
    var notGoing: [Event] = []
    var mayBe: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        
        // Adding events
        var location: Location = Location(name: "ACC", city: "Toronto", country: "Canada", longitude: -79.379278549753, latitude: 43.643263062368)
        
        
        //        let tableView = UITableView()
        //        self.view.addSubview(tableView)
        
        //        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "375003852708970", parameters: nil)
        //        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        //
        //            if ((error) != nil)
        //            {
        //                // Process error
        //                println("Error: \(error)")
        //            }
        //            else
        //            {
        //                println("fetched user: \(result)")
        //                let userName : NSString = result.valueForKey("name") as! NSString
        //                println("User Name is: \(userName)")
        //                let userEmail : NSString = result.valueForKey("email") as! NSString
        //                println("User Email is: \(userEmail)")
        //            }
        //        })
        
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
        var rsvp: Int = -1
        if (contains(self.attending, event)){
            rsvp = 1
        } else if (contains(self.notGoing, event)){
            rsvp = 2
        } else if (contains(self.mayBe, event)){
            rsvp = 3
        }
        let eventDetailsViewController = EventDetailsViewController(event: event, isFavourite: true, rsvp: rsvp)
        
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
        self.attending = []
        self.notGoing = []
        self.mayBe = []
        
        let RSVPObjectQuery = RSVP.query()
        
        User.query()?.getObjectInBackgroundWithId("rdgLaK2buR"){
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
                                if (object.status == 1) {
                                    self.attending.append(object.event)
                                } else if(object.status == 2) {
                                    self.notGoing.append(object.event)
                                } else {
                                    self.mayBe.append(object.event)
                                }
                                
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
        
        let userQuery = User.query()
        
        userQuery?.findObjectsInBackgroundWithBlock {
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
                                    self.events.append(favourite.event)
                                }
                                self.tableView.reloadData()
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
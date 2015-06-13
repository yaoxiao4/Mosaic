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
    var users: [PFUser] = []
    var favourites: [PFObject] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
        
        // Adding events
        var location: Location = Location(name: "ACC", city: "Toronto", country: "Canada", longitude: -79.379278549753, latitude: 43.643263062368)
        
        var event: Event = Event()
        event.title = "Ginger Info Session"
        event.fb_id = "125634fdvd"
        event.location = location
        event.weather = 99
        event.picture_url = "https://scontent-ord1-1.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/11050684_946936308696701_7152001106456242296_n.jpg?oh=aecba138470a9e2e3fad36e8c7ce94aa&oe=563210F9"
        event.details = "This is details"
        event.date = NSDate()
        event.saveInBackground()
        
        
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
        
        let eventObjectQuery = Event.query()
        eventObjectQuery?.includeKey("location")
        eventObjectQuery?.orderByAscending("date")
        
        eventObjectQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.events.append(object)
                        
                    }
                self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
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
                                    self.favourites.append(object)
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


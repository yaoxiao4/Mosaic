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
    var allEvents: [PFObject] = []
    var pastEvents: [PFObject] = []
    var users: [PFUser] = []
    var favourites: [PFObject] = []
    let tableView = UITableView()
    var rsvp: [Event] = []
    var attending: [Event] = []
    var notGoing: [Event] = []
    var mayBe: [Event] = []
    var segmentedControl: UISegmentedControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        if (GlobalVariables.usertype == 2) {
            self.title = "Events"
        } else {
            self.title = "Admin Events"
        }
        // Adding events
        var location: Location = Location(name: "ACC", city: "Toronto", country: "Canada", longitude: -79.379278549753, latitude: 43.643263062368)
        
//        var event: Event = Event()
//        event.title = "Ginger Info Session"
//        event.fb_id = "125634fdvd"
//        event.location = location
//        event.weather = 99
//        event.picture_url = "https://scontent-ord1-1.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/11050684_946936308696701_7152001106456242296_n.jpg?oh=aecba138470a9e2e3fad36e8c7ce94aa&oe=563210F9"
//        event.details = "This is details"
//        event.date = NSDate()
//        event.saveInBackground()
        
        
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
        fetch();
        
        var navigationHeight = self.navigationController?.navigationBar == nil ? self.navigationController!.navigationBar.frame.height : 50
        
        let items = ["All Events", "Favourites", "Attending", "Past Events"]
        self.segmentedControl = UISegmentedControl(items:items)
        self.segmentedControl.frame.origin.x = (self.view.frame.width - self.segmentedControl.frame.width) / 2
        self.segmentedControl.frame.origin.y = navigationHeight + 25
        self.segmentedControl.selectedSegmentIndex = 0
        self.view.addSubview(self.segmentedControl)
        
        self.segmentedControl.addTarget(self, action: "indexChanged:", forControlEvents: UIControlEvents.ValueChanged)
   
        self.tableView.frame = CGRect(x: 0, y: self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height + 5, width: self.view.frame.width, height: self.view.frame.height - self.segmentedControl.frame.height - navigationHeight - 30)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        self.view.addSubview(tableView)
 
        // Settings Button
        let image = UIImage(named: "Settings-25") as UIImage?
        let settingsButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        settingsButton.frame = CGRectMake(0, 0, 25, 25)
        settingsButton.setImage(image, forState: .Normal)
        settingsButton.addTarget(self, action: "onSettingsClick:", forControlEvents: .TouchUpInside)
        var rightButtonItem : UIBarButtonItem = UIBarButtonItem(customView: settingsButton)
        self.navigationItem.setRightBarButtonItem(rightButtonItem, animated: false)
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    func onSettingsClick(sender: AnyObject) {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        
        self.navigationController?.pushViewController(settingsViewController, animated: true)
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
        var isFavourite = contains(self.favourites, event)
        var lala = self.mayBe
        if (contains(self.attending, event)){
            rsvp = 1
        } else if (contains(self.notGoing, event)){
            rsvp = 2
        } else if (contains(self.mayBe, event)){
            rsvp = 3
        }
        
        var isPastEvent = false;
        if (event.date.compare(NSDate()) == NSComparisonResult.OrderedAscending){
            isPastEvent = true;
        }
        let eventDetailsViewController = EventDetailsViewController(event: event, isFavourite: isFavourite, rsvp: rsvp, parentController: self, isPast: isPastEvent)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func fetch(){
        self.allEvents = []
        self.events = []
        self.users = []
        self.favourites = []
        self.rsvp = []
        self.attending = []
        self.notGoing = []
        self.mayBe = []
        
        let RSVPObjectQuery = RSVP.query()
        
        let userId = PFUser.currentUser()?.objectId
        
        User.query()?.getObjectInBackgroundWithId(userId!){
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
                                var date = NSDate()
                                var curEvent = object.event
                                if (curEvent.date.compare(date) == NSComparisonResult.OrderedDescending){
                                    if (object.status == 1) {
                                        self.attending.append(object.event)
                                    } else if(object.status == 2) {
                                        self.notGoing.append(object.event)
                                    } else {
                                        self.mayBe.append(object.event)
                                    }
                                }
                                
                            }
                            if (self.segmentedControl.selectedSegmentIndex == 2){
                                self.events = self.attending
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                    }
                }
                
                
                //Create Favourite Query Once we have queried all the users since
                //Favourite Query is queried based on the current User
                //REMOVE ONCE WE FIND A BETTER WAY TO FETCH CURRENT USER
                
                let favObjectQuery = Favourite.query()
                favObjectQuery?.includeKey("location")
                favObjectQuery?.orderByAscending("date")
                favObjectQuery?.whereKey("isFavourite", equalTo: true)
                favObjectQuery?.whereKey("user", equalTo: user!)
                
                favObjectQuery?.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let objects = objects as? [PFObject] {
                            for object in objects {
                                var favourite = object as! Favourite
                                var date = NSDate()
                                var curEvent = favourite.event
                                if (curEvent.date.compare(date) == NSComparisonResult.OrderedDescending){
                                    self.favourites.append(curEvent)
                                }
                            }
                            if (self.segmentedControl.selectedSegmentIndex == 1){
                                self.events = self.favourites
                                self.tableView.reloadData()
                            }
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
        
        let eventObjectQuery = Event.query()
        eventObjectQuery?.includeKey("location")
        eventObjectQuery?.orderByAscending("date")
        
        eventObjectQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var date = NSDate()
                        var curEvent = object as! Event
                        if (curEvent.date.compare(date) == NSComparisonResult.OrderedDescending){
                            self.allEvents.append(object)
                        } else {
                            self.pastEvents.append(object)
                        }
                        
                    }
                    if (self.segmentedControl.selectedSegmentIndex == 0){
                        self.events = self.allEvents
                        self.tableView.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.events = self.allEvents
            break;
        case 1:
            self.events = self.favourites
            break;
        case 2:
            self.events = self.attending
            break;
        case 3:
            self.events = self.pastEvents
            break;
        default:
            break;
        }
        
        self.tableView.reloadData()
    }
}


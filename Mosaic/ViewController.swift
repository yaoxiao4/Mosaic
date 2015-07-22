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
    var events: [Event] = []
    var allEvents: [Event] = []
    var pastEvents: [Event] = []
    var users: [PFUser] = []
    var favourites: [Event] = []
    let tableView = UITableView()
    var rsvp: [Event] = []
    var attending: [Event] = []
    var notGoing: [Event] = []
    var pastAttending: [Event] = []
    var mayBe: [Event] = []
    var segmentedControl: UISegmentedControl!
    var isSegment = false;

    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(isSegment: Bool, viewTitle: String) {
        self.isSegment = isSegment;
        super.init(nibName: nil, bundle: nil)
        self.title = viewTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding events
        var location: Location = Location(name: "ACC", city: "Toronto", country: "Canada", longitude: -79.379278549753, latitude: 43.643263062368)
        
        
        var navigationHeight = self.navigationController?.navigationBar == nil ? self.navigationController!.navigationBar.frame.height : 50
        
        if (self.isSegment){
            let items = ["All Events", "Favourites", "Attending"]
            self.segmentedControl = UISegmentedControl(items:items)
            self.segmentedControl.frame.origin.x = (self.view.frame.width - self.segmentedControl.frame.width) / 2
            self.segmentedControl.frame.origin.y = navigationHeight + 25
            self.segmentedControl.selectedSegmentIndex = 0
            self.view.addSubview(self.segmentedControl)
            
            self.segmentedControl.addTarget(self, action: "indexChanged:", forControlEvents: UIControlEvents.ValueChanged)
            let tabBarHeight = self.tabBarController?.view.frame.height
            self.tableView.frame = CGRect(x: 0, y: self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height + 5, width: self.view.frame.width, height: self.view.frame.height - self.segmentedControl.frame.height - navigationHeight - 30 - 50)
            
            
            // Settings Button
            let image = UIImage(named: "Settings-25") as UIImage?
            let settingsButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            settingsButton.frame = CGRectMake(0, 0, 25, 25)
            settingsButton.setImage(image, forState: .Normal)
            settingsButton.addTarget(self, action: "onSettingsClick:", forControlEvents: .TouchUpInside)
            var rightButtonItem : UIBarButtonItem = UIBarButtonItem(customView: settingsButton)
            self.navigationItem.setRightBarButtonItem(rightButtonItem, animated: false)
            
            let segmentedControlAttr: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1)]
            //let segmentedControlAttr2: NSDictionary = [NSBackgroundColorAttributeName: UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1), NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.segmentedControl.tintColor = UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1)
            //apply to self.<segmentControlOutletName>.setTitle........
            self.segmentedControl.setTitleTextAttributes(segmentedControlAttr as [NSObject : AnyObject], forState: UIControlState.Normal)
            //self.segmentedControl.setTitleTextAttributes(segmentedControlAttr as [NSObject : AnyObject], forState: UIControlState.Selected)
            
        } else {
            self.tableView.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height - 30)
        }
        

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        self.view.addSubview(tableView)
 
        // Settings Button
        let image = UIImage(named: "Settings-25") as UIImage?
        let settingsButton = UIBarButtonItem(image: image, landscapeImagePhone: image, style: .Plain, target: self, action: "onSettingsClick:")
        settingsButton.tintColor = UIColor.whiteColor();
        
        // Add Button
        let addButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "onAddEventClick:")
        addButton.tintColor = UIColor.whiteColor();
        
        // Edit Button
        let editBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "onEditEventClick:")
        editBtn.tintColor = UIColor.whiteColor();
        
        // Adding buttons to the top right
        var btnArray: NSMutableArray = NSMutableArray(object: settingsButton)
        
        if (GlobalVariables.usertype == 2 && self.title! != "Past Events") {
            btnArray.addObject(addButton)
        }
        
        var btns:NSArray = btnArray
        
        self.navigationItem.setRightBarButtonItems(btns as! [UIBarButtonItem], animated: false)
        
        if (self.title == "Events") {
            self.navigationItem.setLeftBarButtonItem(editBtn, animated: false)
        }
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if(self.title == "Past Events"){
            self.tabBarController?.tabBar.hidden = true
             self.navigationItem.setRightBarButtonItem(nil, animated: false)
        }
        fetch()
        
    }
    
    func onSettingsClick(sender: AnyObject) {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func onAddEventClick(sender: AnyObject) {
        let newEventViewController =  NewEventViewController()
        let navigationController = UINavigationController(rootViewController: newEventViewController)
        self.navigationController?.pushViewController(newEventViewController, animated: true)
        
    }
    
    func onEditEventClick(sender: AnyObject) {
        let delEventViewController = DeleteEventViewController()
        let navigationController = UINavigationController(rootViewController: delEventViewController)
        self.navigationController?.pushViewController(delEventViewController, animated: true)
    }
    
//    MARK: TableView methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell") as! EventTableViewCell
        if (self.events.count > 0){
            var event: Event = self.events[indexPath.row] as Event
            cell.configureCellWithEvent(event)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var event: Event = self.events[indexPath.row] as Event
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
        self.pastEvents = []
        self.pastAttending = []
        
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
                                var curEvent = object.event as Event
                                if (curEvent.date.compare(date) == NSComparisonResult.OrderedDescending){
                                    if (object.status == 1) {
                                        self.attending.append(object.event)
                                    } else if(object.status == 2) {
                                        self.notGoing.append(object.event)
                                    } else {
                                        self.mayBe.append(object.event)
                                    }
                                } else {
                                    if(object.status == 1){
                                        self.pastAttending.append(object.event)
                                    }
                                }
                                
                            }
                            if (self.isSegment && self.segmentedControl.selectedSegmentIndex == 2){
                                self.events = self.attending
                                self.tableView.reloadData()
                            } else if (!self.isSegment){
                                self.events = self.pastAttending
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
                                var curEvent = favourite.event as Event
                                if (curEvent.date.compare(date) == NSComparisonResult.OrderedDescending){
                                    self.favourites.append(curEvent)
                                }
                            }
                            if (self.isSegment && self.segmentedControl.selectedSegmentIndex == 1){
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
                            self.allEvents.append(curEvent)
                        } else {
                            self.pastEvents.append(curEvent)
                        }
                        
                    }
                    if (self.isSegment && self.segmentedControl.selectedSegmentIndex == 0){
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


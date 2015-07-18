//
//  NewEventViewController.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 7/17/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var events: NSMutableArray = []
    var rsvpStatus: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Facebook Events"
        
        var navigationHeight = self.navigationController?.navigationBar == nil ? self.navigationController!.navigationBar.frame.height : 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - navigationHeight - 30)
        self.tableView.registerNib(UINib(nibName: "NewEventTableViewCell", bundle: nil), forCellReuseIdentifier: "NewEventTableViewCell")
        self.view.addSubview(tableView)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.fetchEvents()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//   MARK: tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: NewEventTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewEventTableViewCell") as! NewEventTableViewCell
        cell.configureCellWithEvent(self.events[indexPath.row] as! Event, status: rsvpStatus[indexPath.row] as! String)
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    
    
//    MARK: API calls
    
    func fetchEvents() {
        
        let eventRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/events", parameters: nil)
        eventRequest.startWithCompletionHandler({ (conn: FBSDKGraphRequestConnection!, eventResult: AnyObject!, err: NSError!) -> Void in
            
            if (err != nil) {
                println("Couldn't fetch events info")
                println("Error: \(err)")
            } else {
                var fbEvents = eventResult.valueForKey("data") as! NSArray
                
                for event in fbEvents {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeZone = NSTimeZone(name: event.valueForKey("timezone") as! String)
                    
                    var newEvent = Event()
                    newEvent.title = event.valueForKey("name") as! String
                    newEvent.fb_id = event.valueForKey("id") as! String
                    
                    // Check if the event already exist
                    let query = PFQuery(className: "Event")
                    query.whereKey("fb_id", equalTo: newEvent.fb_id)
                    let eventArray = query.findObjects()
                    if (eventArray!.count > 0) {
                        continue
                    }
                    
                    // Get the date
                    var dateStr = event.valueForKey("start_time") as! String
                    if (dateStr != "") {
                        dateStr = dateStr.stringByReplacingOccurrencesOfString("T", withString: " ")
                        let dateArr = dateStr.componentsSeparatedByString(" ")
                        if (dateArr.count > 1) {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
                        } else {
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                        }
                        
                        newEvent.date = dateFormatter.dateFromString(dateStr)!
                        newEvent.hasStartDate = true
                    }
                    
                    let eventDetailsRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/" + newEvent.fb_id + "?fields=cover,description,place,start_time", parameters: nil)
                    eventDetailsRequest.startWithCompletionHandler({ (conn1: FBSDKGraphRequestConnection!, res: AnyObject!, err1: NSError!) -> Void in
                        
                        if (err1 != nil) {
                            println("Couldn't fetch events info (Inner loop")
                            println("Error: \(err)")
                        } else {
                            
                            // Event details
                            if (res.valueForKey("description") != nil){
                                newEvent.details = res.valueForKey("description") as! String
                            } else {
                                newEvent.details = "No Description Available"
                            }

                            // Event cover photos
                            if var cover = res.valueForKey("cover") as? NSDictionary {
                                newEvent.picture_url = cover.valueForKey("source") as! String
                            }
                            
                            
                            // Location
                            var place = res.valueForKey("place") as! NSDictionary
                            var locName = place.valueForKey("name") as! String
                            if var loc = place.valueForKey("location") as? NSDictionary {
                                var city = loc.valueForKey("city") as! String
                                var country = loc.valueForKey("country") as! String
                                var longitude = loc.valueForKey("longitude") as! CLLocationDegrees
                                var latitude = loc.valueForKey("latitude") as! CLLocationDegrees
                                
                                newEvent.location = Location(name: locName, city: city, country: country, longitude: longitude, latitude: latitude)
                            }

                            
                        }
                    
                    })
                    

                    self.rsvpStatus.addObject(event.valueForKey("rsvp_status") as! String)
                    self.events.addObject(newEvent)
                }
                self.tableView.reloadData()
            }
            
        })
    }



}

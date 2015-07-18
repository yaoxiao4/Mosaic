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
        cell.configureCellWithEvent(self.events[indexPath.row] as! Event)
        cell.addRemoveBtn.setTitle("Add", forState: .Normal)
        cell.addRemoveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
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
                    println(event)
                    newEvent.title = event.valueForKey("name") as! String
                    newEvent.fb_id = event.valueForKey("id") as! String
                    var dateStr = event.valueForKey("start_time") as! String
                    dateStr = dateStr.stringByReplacingOccurrencesOfString("T", withString: " ")
                    let dateArr = dateStr.componentsSeparatedByString(" ")
                    if (dateArr.count > 1) {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
                    } else {
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                    }
                    
                    newEvent.date = dateFormatter.dateFromString(dateStr)!
                    self.rsvpStatus.addObject(event.valueForKey("rsvp_status") as! String)
                    self.events.addObject(newEvent)
                }
                self.tableView.reloadData()
            }
            
        })
    }



}

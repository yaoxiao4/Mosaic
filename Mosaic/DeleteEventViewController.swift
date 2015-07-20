//
//  DeleteEventViewController.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 7/19/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit

class DeleteEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var events: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Your Events"
        
        var navigationHeight = self.navigationController?.navigationBar == nil ? self.navigationController!.navigationBar.frame.height : 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - navigationHeight - 30)
        self.tableView.registerNib(UINib(nibName: "NewEventTableViewCell", bundle: nil), forCellReuseIdentifier: "NewEventTableViewCell")
        self.view.addSubview(tableView)
        
        self.view.backgroundColor = UIColor.whiteColor()
        fetchEvent()

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
    
    // MARK: Tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: NewEventTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewEventTableViewCell") as! NewEventTableViewCell
        cell.configureCellForDeleteEvent(self.events[indexPath.row] as! Event)
//        cell.configureCellWithEvent(self.events[indexPath.row] as! Event, status: rsvpStatus[indexPath.row] as! String)
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }

    func fetchEvent() {
        // Check if the event already exist
        let query = PFQuery(className: "Event")
        query.whereKey("added_by", equalTo: PFUser.currentUser()!)
        let arr = query.findObjects()
        let eventsArray = arr as! [Event]
        if (eventsArray.count == 0) {
            return
        }
        
        for event in eventsArray {
            self.events.addObject(event)
        }
    }

}

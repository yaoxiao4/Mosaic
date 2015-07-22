//
//  UWOpenDataViewController.swift
//  Mosaic
//
//  Created by Renato Fernandes on 2015-07-15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import UIKit
class UWOpenDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView?
    var items = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UW Events"
        
        let frame:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view.addSubview(self.tableView!)
        
        self.tableView!.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        
        // Settings Button
        let image = UIImage(named: "Settings-25") as UIImage?
        let settingsButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        settingsButton.frame = CGRectMake(0, 0, 25, 25)
        settingsButton.setImage(image, forState: .Normal)
        settingsButton.addTarget(self, action: "onSettingsClick:", forControlEvents: .TouchUpInside)
        var rightButtonItem : UIBarButtonItem = UIBarButtonItem(customView: settingsButton)
        self.navigationItem.setRightBarButtonItem(rightButtonItem, animated: false)
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        addDummyData()
    }
    
    func onSettingsClick(sender: AnyObject) {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func addDummyData() {
        UWOpenDataAPIManager.sharedInstance.getEvents { json in
            let results = json["data"]
            let dateFormatter = NSDateFormatter()
            
            // Check date
            let calendar = NSCalendar.currentCalendar()
            let today = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss";
            
            for (index: String, subJson: JSON) in results {
                if(self.items.count >= 40){
                    break;
                }
                var object = JSON(subJson.object)
                
                for (var a = 0; a < object["times"].count; a++){
                    let dateString = object["times"][a]["start"].string!
                    
                    let date = dateString.substringWithRange(Range(start: dateString.startIndex,
                        end: advance(dateString.startIndex, 19)))
                    var realDate = dateFormatter.dateFromString(date)!
                    if (today?.compare(realDate) == NSComparisonResult.OrderedAscending){
                        self.items.addObject(subJson.object)
                        break;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    tableView?.reloadData()
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell") as! EventTableViewCell
        let event:JSON =  JSON(self.items[indexPath.row])
        cell.configureJsonEvent(event)

        
        var s = event["title"].string as String?
        var s1 = s?.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var s2 = s1?.stringByReplacingOccurrencesOfString("&quot;", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var realEvent: Event = createEvent(JSON(self.items[indexPath.row]));
        var rsvp: Int = -1;
        var isFavourite = false;
        var isPastEvent = false;

        let eventDetailsViewController = EventDetailsViewController(event: realEvent, isFavourite: false, rsvp: rsvp, parentController: nil, isPast: false);
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func createEvent(JSONEvent: JSON) -> Event {
        var location: Location = Location(name: JSONEvent["site_name"].string!, city: "Waterloo", country: "Canada", longitude: -80.540, latitude: 43.468)
        
        var s = JSONEvent["title"].string as String?
        var s1 = s?.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var s2 = s1?.stringByReplacingOccurrencesOfString("&quot;", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var event: Event = Event()
        
        let calendar = NSCalendar.currentCalendar()
        let today = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss";
        for (var a = 0; a <  JSONEvent["times"].count; a++){
            let dateString = JSONEvent["times"][a]["start"].string!
            
            let date = dateString.substringWithRange(Range(start: dateString.startIndex,
                end: advance(dateString.startIndex, 19)))
            var realDate = dateFormatter.dateFromString(date)!
            if (today?.compare(realDate) == NSComparisonResult.OrderedAscending){
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                event.date = realDate
                break;
            }
        }
        
        event.title = s2!
        event.fb_id = ""
        event.location = location
        event.weather = 99
        event.picture_url = ""
        event.details = (JSONEvent["link"].string as String?)!
        event.hasStartDate = true
        event.isUWEvent = true

        return event;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
}

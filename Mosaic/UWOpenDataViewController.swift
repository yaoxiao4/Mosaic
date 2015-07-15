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
            var today = NSDate()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss";
            
            for (index: String, subJson: JSON) in results {
                if(self.items.count >= 40){
                    break;
                }
                var object = JSON(subJson.object)
                
                for (var a = 0; a <  object["times"].count; a++){
                    let dateString = object["times"][a]["start"].string!
                    
                    let date = dateString.substringWithRange(Range(start: dateString.startIndex,
                        end: advance(dateString.startIndex, 19)))
                    var realDate = dateFormatter.dateFromString(date)!
                    if (today.compare(realDate) == NSComparisonResult.OrderedAscending){
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
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
//        
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
//        }
//        
//        let event:JSON =  JSON(self.items[indexPath.row])
//        
////        let picURL = user["picture"]["medium"].string
////        let url = NSURL(string: picURL!)
////        let data = NSData(contentsOfURL: url!)
//        
//        cell!.textLabel?.text = event["title"].string
        //cell?.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
}

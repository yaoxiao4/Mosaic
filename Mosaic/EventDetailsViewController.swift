//
//  EventDetailsViewController.swift
//  Mosaic
//
//  Created by Yao Xiao on 2015-05-27.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import UIKit
class EventDetailsViewController: UIViewController {
    
    var event: Event? = nil
    var descriptionScrollView: UIScrollView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.title = "Event Details"
        //self.navigationItem.hidesBackButton = true
        
        // This block handles the join button
        let joinButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        joinButton.frame = CGRectMake(100, 100, 100, 50)
        joinButton.setTitle("Join", forState: .Normal)
        joinButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        let barButton = UIBarButtonItem(customView: joinButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        // This block handles the title
        let eventTitleLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 90, 90, 225, 10))
        eventTitleLabel.text =  self.event?.title
        eventTitleLabel.textAlignment = NSTextAlignment.Left;
        eventTitleLabel.lineBreakMode = .ByWordWrapping;
        eventTitleLabel.numberOfLines = 0;
        eventTitleLabel.sizeToFit();
        eventTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        self.view.addSubview(eventTitleLabel)
        
        ///////////////
        //   BEGIN DETAILS
        ///////////////
        // This block handles the details box
        let eventDetailsBox = UIView(frame: CGRectMake(0, 120 + eventTitleLabel.frame.height, self.view.frame.width, 120))
        eventDetailsBox.backgroundColor = UIColor.whiteColor()
        
        // For Location
        let eventLocationLabel = UILabel(frame: CGRectMake(85, 10, 200, 30))
        eventLocationLabel.text = self.event!.location
        eventLocationLabel.textAlignment = .Left;
        eventDetailsBox.addSubview(eventLocationLabel)
        let locationIconView = UIImageView(frame: CGRectMake(35, 10, 28, 23))
        var locationIcon = UIImage(named: "location-icon.png")
        locationIconView.image = locationIcon
        eventDetailsBox.addSubview(locationIconView)
        
        // For Date
        let eventDateLabel = UILabel(frame: CGRectMake(85, eventLocationLabel.frame.origin.y + 35,200,30))
        let dateFormatter = NSDateFormatter()
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
        dateFormatter.dateStyle = theDateFormat//8
        dateFormatter.timeStyle = theTimeFormat//9
        eventDateLabel.text = dateFormatter.stringFromDate(self.event!.date)
        eventDateLabel.textAlignment = .Left;
        let dateIconView = UIImageView(frame: CGRectMake(35, eventLocationLabel.frame.origin.y + 35, 28, 28))
        var dateIcon = UIImage(named: "calendar-icon.png")
        dateIconView.image = dateIcon
        eventDetailsBox.addSubview(dateIconView)

        eventDetailsBox.addSubview(eventDateLabel)
        
        // For Time
        let eventTimeLabel = UILabel(frame: CGRectMake(85, eventDateLabel.frame.origin.y + 35, 200, 30))
        eventTimeLabel.text = "2:30PM - 3:30PM"
        eventTimeLabel.textAlignment = .Left;
        eventDetailsBox.addSubview(eventTimeLabel)
        let timeIconView = UIImageView(frame: CGRectMake(35, eventDateLabel.frame.origin.y + 35, 28, 28))
        var timeIcon = UIImage(named: "clock-icon.png")
        timeIconView.image = timeIcon
        
        eventDetailsBox.addSubview(timeIconView)
        
        self.view.addSubview(eventDetailsBox)
        
        /////////// END EVENT DETAILS
        
        // This block handles the FB icon (if it is a FB Event)
        var fbIconView = UIImageView(frame: CGRectMake(self.view.frame.width/8 - 20, 70 + eventTitleLabel.frame.height/2, 40, 40));
        var fbIcon = UIImage(named: "facebook-icon.png");
        fbIconView.image = fbIcon;
        self.view.addSubview(fbIconView);
        
        // This block handles the bookmark icon
        var bookmarkView = UIImageView(frame: CGRectMake(eventTitleLabel.frame.width + eventTitleLabel.frame.origin.y + 50, 75 + eventTitleLabel.frame.height/2, 30, 30));
        var bookmarkIcon = UIImage(named: "star-empty.png");
        bookmarkView.image = bookmarkIcon;
        self.view.addSubview(bookmarkView);
        
        // This block handles the title
        
        let eventDescriptionLabel = UILabel(frame: CGRectMake(25, 20, self.view.frame.width - 50, 30))
        eventDescriptionLabel.text =  self.event?.details
        eventDescriptionLabel.textAlignment = NSTextAlignment.Left;
        eventDescriptionLabel.lineBreakMode = .ByWordWrapping;
        eventDescriptionLabel.numberOfLines = 0;
        eventDescriptionLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        eventDescriptionLabel.sizeToFit();
        
        // This block handles the details box
        let eventDescriptionBox = UIView(frame: CGRectMake(0, 0, self.view.frame.width, eventDescriptionLabel.bounds.height + 40))
        eventDescriptionBox.backgroundColor = UIColor.whiteColor()
        
        eventDescriptionBox.addSubview(eventDescriptionLabel)

        
        
        descriptionScrollView = UIScrollView(frame: CGRectMake(0, 20 + eventDetailsBox.frame.height + eventDetailsBox.frame.origin.y, eventDescriptionBox.frame.width, eventDescriptionBox.frame.height))
        descriptionScrollView.backgroundColor = UIColor.blackColor()
        // 3
        descriptionScrollView.contentSize = CGSize(width: self.view.frame.width, height: 500)
        // 4
        descriptionScrollView.addSubview(eventDescriptionBox)
        descriptionScrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(descriptionScrollView)
    }
    
    @IBAction func close(sender: AnyObject) {
        let nextController = ViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
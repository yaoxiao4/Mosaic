//
//  EventDetailsViewController.swift
//  Mosaic
//
//  Created by Yao Xiao on 2015-05-27.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class EventDetailsViewController: UIViewController, UIScrollViewDelegate {
    var event: Event? = nil
    var scrollView: UIScrollView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ///////////////
        // Scroll View
        ///////////////
        scrollView = UIScrollView(frame: CGRectMake(0,0, self.view.bounds.width, self.view.bounds.height))
        scrollView.backgroundColor = UIColor.blackColor()
        // 3
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.bounds.height - self.navigationController!.navigationBar.frame.height - 20)
        scrollView.delegate = self
        
        scrollView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.view.addSubview(scrollView)
        //// END SCROLL VIEW
        
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.title = "Event Details"

        // This block handles the join button
        let joinButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        joinButton.frame = CGRectMake(100, 100, 100, 50)
        joinButton.setTitle("Join", forState: .Normal)
        joinButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        let barButton = UIBarButtonItem(customView: joinButton)
        //self.navigationItem.rightBarButtonItem = barButton
        
        // This block handles the title
        let eventTitleLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 90, 25, 225, 10))
        eventTitleLabel.text =  self.event?.title
        eventTitleLabel.textAlignment = NSTextAlignment.Left;
        eventTitleLabel.lineBreakMode = .ByWordWrapping;
        eventTitleLabel.numberOfLines = 0;
        eventTitleLabel.sizeToFit();
        eventTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        scrollView.addSubview(eventTitleLabel)
        
        // This block handles the FB icon (if it is a FB Event)
        var fbIconView = UIImageView(frame: CGRectMake(self.view.frame.width/8 - 20, 10 + eventTitleLabel.frame.height/2, 40, 40));
        var fbIcon = UIImage(named: "facebook-icon.png");
        fbIconView.image = fbIcon;
        scrollView.addSubview(fbIconView);
        
        // This block handles the bookmark icon
        var bookmarkView = UIImageView(frame: CGRectMake(eventTitleLabel.frame.origin.x + eventTitleLabel.frame.width + 55, 13 + eventTitleLabel.frame.height/2, 30, 30));
        var bookmarkIcon = UIImage(named: "star-empty.png");
        bookmarkView.image = bookmarkIcon;
        scrollView.addSubview(bookmarkView);

        
        ///////////////
        //   BEGIN DETAILS
        ///////////////
        // This block handles the details box
        let eventDetailsBox = UIView(frame: CGRectMake(0, 40 + eventTitleLabel.frame.origin.y + eventTitleLabel.frame.height, self.view.frame.width, 120))
        eventDetailsBox.backgroundColor = UIColor.whiteColor()
        
        // For Location
        let eventLocationLabel = UILabel(frame: CGRectMake(95, 10, 200, 30))
        eventLocationLabel.text = self.event!.location?.name
        eventLocationLabel.textAlignment = .Left;
        eventLocationLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        eventDetailsBox.addSubview(eventLocationLabel)
        let locationIconView = UIImageView(frame: CGRectMake(35, 10, 28, 23))
        var locationIcon = UIImage(named: "location-icon.png")
        locationIconView.image = locationIcon
        eventDetailsBox.addSubview(locationIconView)
        
        // Enable Touch
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "pushOnMap")
        locationIconView.addGestureRecognizer(singleTap)
        locationIconView.userInteractionEnabled = true
        
        // For Date
        let eventDateLabel = UILabel(frame: CGRectMake(95, eventLocationLabel.frame.origin.y + 35,200,30))
        let dateFormatter = NSDateFormatter()
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        dateFormatter.dateStyle = theDateFormat//8
        eventDateLabel.text = dateFormatter.stringFromDate(self.event!.date)
        eventDateLabel.textAlignment = .Left;
        eventDateLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        let dateIconView = UIImageView(frame: CGRectMake(35, eventLocationLabel.frame.origin.y + 35, 28, 28))
        var dateIcon = UIImage(named: "calendar-icon.png")
        dateIconView.image = dateIcon
        eventDetailsBox.addSubview(dateIconView)

        eventDetailsBox.addSubview(eventDateLabel)
        
        // For Time
        let eventTimeLabel = UILabel(frame: CGRectMake(95, eventDateLabel.frame.origin.y + 35, 200, 30))
        eventTimeLabel.text = "2:30PM - 3:30PM"
        eventTimeLabel.textAlignment = .Left;
        eventTimeLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        eventDetailsBox.addSubview(eventTimeLabel)
        let timeIconView = UIImageView(frame: CGRectMake(35, eventDateLabel.frame.origin.y + 35, 28, 28))
        var timeIcon = UIImage(named: "clock-icon.png")
        timeIconView.image = timeIcon
        
        eventDetailsBox.addSubview(timeIconView)
        
        scrollView.addSubview(eventDetailsBox)
        
        //   END EVENT DETAILS
        
        ///////////////
        //   BEGIN BUTTON GROUP
        ///////////////
        let actionButtonsBox = UIView(frame: CGRectMake(0, 20 + eventDetailsBox.frame.origin.y + eventDetailsBox.frame.height, self.view.frame.width, 50))
        actionButtonsBox.backgroundColor = UIColor.whiteColor()
        
        let items = ["Not Going", "Maybe", "Going"]
        let segmentedControl = UISegmentedControl(items:items)
        segmentedControl.frame.origin.x = (actionButtonsBox.frame.width - segmentedControl.frame.width) / 2
        segmentedControl.frame.origin.y = (actionButtonsBox.frame.height - segmentedControl.frame.height) / 2
        actionButtonsBox.addSubview(segmentedControl)
        
        scrollView.addSubview(actionButtonsBox)
        //   END BUTTON GROUP
        
        // This block handles the cover photo
        let eventPhotoView = UIImageView(frame: CGRectMake(0, actionButtonsBox.frame.origin.y + actionButtonsBox.frame.height, self.view.frame.width, 0))
        if (event?.picture_url != nil){
            let coverURL = NSURL(string: event!.picture_url)
            let data = NSData(contentsOfURL: coverURL!) //make sure image in this url does exist, otherwise unwrap in a if let check
            if (data != nil){
                let eventPhoto = UIImage(data: data!)
                eventPhotoView.frame.size.height = (self.view.frame.width / eventPhoto!.size.width) * eventPhoto!.size.height
                eventPhotoView.contentMode = .ScaleAspectFit
                eventPhotoView.image = UIImage(data: data!)
            }
        }
        
        scrollView.addSubview(eventPhotoView)
        
        // This block handles the description
        
        let eventDescriptionLabel = UILabel(frame: CGRectMake(25, 20, self.view.frame.width - 50, 30))
       
        if (self.event?.details == ""){
            eventDescriptionLabel.text = "No Details Available"
        } else {
            eventDescriptionLabel.text =  self.event?.details
        }
        eventDescriptionLabel.textAlignment = NSTextAlignment.Left;
        eventDescriptionLabel.lineBreakMode = .ByWordWrapping;
        eventDescriptionLabel.numberOfLines = 0;
        eventDescriptionLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        eventDescriptionLabel.sizeToFit();
        
        // This block handles the details box
        let eventDescriptionBox = UIView(frame: CGRectMake(0, eventPhotoView.frame.origin.y + eventPhotoView.frame.height + 20, self.view.frame.width, eventDescriptionLabel.bounds.height + 40))
        eventDescriptionBox.backgroundColor = UIColor.whiteColor()
        
        eventDescriptionBox.addSubview(eventDescriptionLabel)
        scrollView.addSubview(eventDescriptionBox)

        /////////// RESIZE SCROLL VIEW TO FIT THE DESCRIPTION
        self.scrollView.contentSize.height = eventDescriptionBox.frame.height + eventDescriptionBox.frame.origin.y
    }
    
    @IBAction func close(sender: AnyObject) {
        let nextController = ViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    @IBAction func openMap(){
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    
    @IBAction func pushOnMap(){
        let googleMapsController = GoogleMapsViewController(event: self.event!)
        self.navigationController?.pushViewController(googleMapsController, animated: true)
    }
}
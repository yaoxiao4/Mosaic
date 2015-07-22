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
import WebKit

class EventDetailsViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    var event: Event? = nil
    var scrollView: UIScrollView!
    var segmentedControl: UISegmentedControl!
    var isFavourite: Bool = false
    var bookmarkView: UIImageView!
    var isPastEvent: Bool = false
    var parentController: ViewController!
    var RSVPStatus: Int = 0; // 0 no res, 1 attend, 2 no, 3 maybe
    
    var backgroundWebView: UIWebView!;
    var webView: UIWebView!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(event: Event, isFavourite: Bool, rsvp: Int, parentController: ViewController!, isPast: Bool) {
        self.parentController = parentController
        self.isFavourite = isFavourite
        self.RSVPStatus = rsvp
        self.event = event
        self.isPastEvent = isPast
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollViewHeight: CGFloat = self.view.bounds.height - self.navigationController!.navigationBar.frame.height - 20
        
        self.title = "Event Details"
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tabBarController?.tabBar.hidden = true
        
        // Scroll View
        scrollView = UIScrollView(frame: CGRectMake(0,0, self.view.bounds.width, self.view.bounds.height))
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollViewHeight)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.view.addSubview(scrollView)
        // End Scroll View
        
        // Join Button
        let joinButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        joinButton.frame = CGRectMake(100, 100, 100, 50)
        joinButton.setTitle("Join", forState: .Normal)
        joinButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        let barButton = UIBarButtonItem(customView: joinButton)
        // End Join Button
        
        // Title
        let eventTitleLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 90, 25, 200, 10))
        eventTitleLabel.text =  self.event?.title
        eventTitleLabel.textAlignment = NSTextAlignment.Left;
        eventTitleLabel.lineBreakMode = .ByWordWrapping;
        eventTitleLabel.numberOfLines = 0;
        eventTitleLabel.sizeToFit();
        eventTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        scrollView.addSubview(eventTitleLabel)
        // End Title
        
        // FB Icon
        var fbIconView = UIImageView(frame: CGRectMake(self.view.frame.width/8 - 20, 10 + eventTitleLabel.frame.height/2, 40, 40));
        var fbIcon: UIImage!
        
        if (event?.isUWEvent == false) {
            fbIcon = UIImage(named: "facebook-icon.png");
        } else {
            fbIcon = UIImage(named: "waterloo.png");
        }
        
        fbIconView.image = fbIcon;
        scrollView.addSubview(fbIconView);

        // End FB Icon
        
        if (event?.isUWEvent == false) {
            // This block handles the bookmark icon
            self.bookmarkView = UIImageView(frame: CGRectMake(eventTitleLabel.frame.origin.x + 150 + 55, 13 + eventTitleLabel.frame.height/2, 30, 30));
            if (self.isFavourite == true) {
                bookmarkView.image = UIImage(named: "star-filled.png");
            } else {
                bookmarkView.image = UIImage(named: "star-empty.png");
            }
            scrollView.addSubview(bookmarkView);
        
            // Enable Touch
            bookmarkView.userInteractionEnabled = true;
            bookmarkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "bookmarkEvent"))
        }
        
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
        // Enable Touch
        locationIconView.userInteractionEnabled = true;
        locationIconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openMap"))
        eventDetailsBox.addSubview(locationIconView)
        
        var locationSeparator = UIView(frame: CGRectMake(35, 40, self.view.frame.width - 70, 0.5))
        locationSeparator.backgroundColor = UIColor.blackColor()
        eventDetailsBox.addSubview(locationSeparator)
        
        var viewMapButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        viewMapButton.frame = CGRectMake(295, 10, 50, 30)
        viewMapButton.setTitle("Map", forState: .Normal)
        viewMapButton.setTitleColor(UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1), forState: UIControlState.Normal)
        viewMapButton.addTarget((self), action: "pushOnMap", forControlEvents: UIControlEvents.TouchUpInside)
        
        eventDetailsBox.addSubview(viewMapButton)
        
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
        
        
        var getDirectionButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        getDirectionButton.frame = CGRectMake(213, 45, 150, 30)
        getDirectionButton.setTitle("Get Directions", forState: .Normal)
        getDirectionButton.setTitleColor(UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1), forState: UIControlState.Normal)
        getDirectionButton.addTarget((self), action: "openMap", forControlEvents: UIControlEvents.TouchUpInside)
        
        eventDetailsBox.addSubview(getDirectionButton)

        eventDetailsBox.addSubview(eventDateLabel)
        var dateSeparator = UIView(frame: CGRectMake(35, eventLocationLabel.frame.origin.y + 67, self.view.frame.width - 70, 0.5))
        dateSeparator.backgroundColor = UIColor.blackColor()
        eventDetailsBox.addSubview(dateSeparator)
        
        // For Time
        let eventTimeLabel = UILabel(frame: CGRectMake(95, eventDateLabel.frame.origin.y + 35, 200, 30))
        if (self.event!.hasStartDate == true){
            var timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            eventTimeLabel.text = timeFormatter.stringFromDate(self.event!.date)
        } else {
            eventTimeLabel.text = "Unspecified"
        }
        eventTimeLabel.textAlignment = .Left;
        eventTimeLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        eventDetailsBox.addSubview(eventTimeLabel)
        let timeIconView = UIImageView(frame: CGRectMake(35, eventDateLabel.frame.origin.y + 35, 28, 28))
        var timeIcon = UIImage(named: "clock-icon.png")
        timeIconView.image = timeIcon
        
        eventDetailsBox.addSubview(timeIconView)
        
        scrollView.addSubview(eventDetailsBox)
        
        //   END EVENT DETAILS
        
        var photoViewY: CGFloat = eventDetailsBox.frame.origin.y + eventDetailsBox.frame.height
        var photoViewHeight: CGFloat = 0.0
        
        if (event?.isUWEvent == false) {
            ///////////////
            //   BEGIN BUTTON GROUP
            ///////////////
            
            let actionButtonsBox = UIView(frame: CGRectMake(0, 20 + eventDetailsBox.frame.origin.y + eventDetailsBox.frame.height, self.view.frame.width, 50))
            actionButtonsBox.backgroundColor = UIColor.whiteColor()
            
            let items = ["Not Going", "Maybe", "Going"]
            self.segmentedControl = UISegmentedControl(items:items)
            
            let segmentedControlAttr: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1)]
            //let segmentedControlAttr2: NSDictionary = [NSBackgroundColorAttributeName: UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1), NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.segmentedControl.tintColor = UIColor(red: 245/255, green: 67/255, blue: 60/255, alpha: 1)
            //apply to self.<segmentControlOutletName>.setTitle........
            self.segmentedControl.setTitleTextAttributes(segmentedControlAttr as [NSObject : AnyObject], forState: UIControlState.Normal)
            //self.segmentedControl.setTitleTextAttributes(segmentedControlAttr as [NSObject : AnyObject], forState: UIControlState.Selected)

            
            segmentedControl.frame.origin.x = (actionButtonsBox.frame.width - segmentedControl.frame.width) / 2
            segmentedControl.frame.origin.y = (actionButtonsBox.frame.height - segmentedControl.frame.height) / 2
            actionButtonsBox.addSubview(segmentedControl)
            
            switch self.RSVPStatus {
                case 1:
                    self.segmentedControl.selectedSegmentIndex = 2
                    break;
                case 2:
                    self.segmentedControl.selectedSegmentIndex = 0
                    break;
                case 3:
                    self.segmentedControl.selectedSegmentIndex = 1
                    break;
                default:
                    break;
            }
            self.segmentedControl.addTarget(self, action: "indexChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
            scrollView.addSubview(actionButtonsBox)
            //   END BUTTON GROUP

        
            // This block handles the cover photo
            let eventPhotoView = UIImageView(frame: CGRectMake(0, actionButtonsBox.frame.origin.y + actionButtonsBox.frame.height, self.view.frame.width, 0))
            if (event?.picture_url != nil){
                let coverURL = NSURL(string: event!.picture_url)
                let img = GlobalVariables.imageCache[event!.picture_url]
                eventPhotoView.frame.size.height = (self.view.frame.width / img!.size.width) * img!.size.height
                eventPhotoView.contentMode = .ScaleAspectFit
                eventPhotoView.image = img
            }
            
            scrollView.addSubview(eventPhotoView)
            photoViewY = eventPhotoView.frame.origin.y;
            photoViewHeight = eventPhotoView.frame.height;
        }
        
        // This block handles the description
        let eventDescriptionLabel = UILabel(frame: CGRectMake(25, 20, self.view.frame.width - 50, 30))

        if (event?.isUWEvent == true) {
            var moreDetailsButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            moreDetailsButton.frame = CGRectMake(self.view.frame.width/2 - 50, photoViewY + photoViewHeight + 20, 100, 30)
            moreDetailsButton.setTitle("More Details", forState: .Normal)
            moreDetailsButton.addTarget((self), action: "pushOnUWWebView", forControlEvents: UIControlEvents.TouchUpInside)
            
            scrollView.addSubview(moreDetailsButton)
        } else {
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
            let eventDescriptionBox = UIView(frame: CGRectMake(0, photoViewY + photoViewHeight + 20, self.view.frame.width, eventDescriptionLabel.bounds.height + 40))
            eventDescriptionBox.backgroundColor = UIColor.whiteColor()
            eventDescriptionBox.addSubview(eventDescriptionLabel)
            scrollView.addSubview(eventDescriptionBox)
            self.scrollView.contentSize.height = eventDescriptionBox.frame.height + eventDescriptionBox.frame.origin.y
        }
        
        if (self.isPastEvent) {
            self.bookmarkView.hidden = true;
            self.segmentedControl.hidden = true;
        }
    }
    
    @IBAction func openMap(){
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            //var long = self.event!.location!.longitude
            
            var urlstringOne =  "comgooglemaps://?daddr=" + "\(self.event!.location!.latitude)"
            var urlstringTwo = urlstringOne + "," + "\(self.event!.location!.longitude)" + "&directionsmode=driving"
            UIApplication.sharedApplication().openURL(NSURL(string:urlstringTwo)!)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    @IBAction func pushOnMap(){
        let googleMapsController = GoogleMapsViewController(event: self.event!)
        self.navigationController?.pushViewController(googleMapsController, animated: true)
    }
    
    @IBAction func pushOnUWWebView(){
        let uwWebViewController = UWWebViewController(url: self.event!.details)
        self.navigationController?.pushViewController(uwWebViewController, animated: true)
    }

    @IBAction func bookmarkEvent(){
        if (self.isFavourite){
            self.bookmarkView.image = UIImage(named: "star-empty.png");
        } else {
            self.bookmarkView.image = UIImage(named: "star-filled.png");
        }
        
        let userId = PFUser.currentUser()?.objectId
        
        User.query()?.getObjectInBackgroundWithId(userId!){
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                // REPLACE LATER
                var favouriteQuery = Favourite.query()
                var storedFav: Favourite? = nil
                favouriteQuery?.whereKey("event", equalTo: self.event!)
                favouriteQuery?.whereKey("user", equalTo: user!)
                favouriteQuery?.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let objects = objects as? [PFObject] {
                            for object in objects {
                                storedFav = object as? Favourite
                            }
                            
                            if (storedFav == nil){
                                var favourite = Favourite()
                                favourite.event = self.event!
                                favourite.user = user!;
                                favourite.isFavourite = !self.isFavourite
                                
                                favourite.saveInBackground()
                            } else {
                                storedFav?.isFavourite = !self.isFavourite
                                storedFav?.saveInBackground()
                            }
                            
                            self.isFavourite = !self.isFavourite
                            self.parentController.fetch()
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
        
    }
    
    override func viewWillDisappear(animated:Bool) {
        if (self.navigationController?.topViewController is ViewController){
            var controller = self.navigationController?.topViewController as! ViewController
            self.tabBarController?.tabBar.hidden = false
        } else if (self.navigationController?.topViewController is UWOpenDataViewController) {
            var controller = self.navigationController?.topViewController as! UWOpenDataViewController
            self.tabBarController?.tabBar.hidden = false
        }

        super.viewWillDisappear(animated)
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        if (event?.isUWEvent == false) {
            let userId = PFUser.currentUser()?.objectId
            
            User.query()?.getObjectInBackgroundWithId(userId!){
                (user: PFObject?, error: NSError?) -> Void in
                if error == nil && user != nil {
                    // REPLACE LATER
                    var rsvpQuery = RSVP.query()
                    var storedRSVP: RSVP? = nil
                    rsvpQuery?.whereKey("event", equalTo: self.event!)
                    rsvpQuery?.whereKey("user", equalTo: user!)
                    rsvpQuery?.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    storedRSVP = object as? RSVP
                                }
                                
                                var statusValue = -1
                                var eventId = self.event?.fb_id
                                var rsvpResponse: String?
                                
                                if (self.segmentedControl.selectedSegmentIndex == 0){
                                    statusValue = 2
                                    rsvpResponse = "declined"
                                } else if (self.segmentedControl.selectedSegmentIndex == 1) {
                                    statusValue = 3
                                    rsvpResponse = "maybe"
                                } else if (self.segmentedControl.selectedSegmentIndex == 2) {
                                    statusValue = 1
                                    rsvpResponse = "attending"
                                }
                                
                                
                                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: eventId! + "/" + rsvpResponse!, parameters: nil, HTTPMethod: "Post")
                                graphRequest.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                                    if error != nil {
                                        println("facebook has the following error on trying to change rsvp")
                                    } else {
                                        
                                    }
                                })
                                
                                if (storedRSVP == nil){
                                    var newRSVP = RSVP()
                                    newRSVP.event = self.event!
                                    newRSVP.user = user!;
                                    newRSVP.status = statusValue
                                    newRSVP.saveInBackground()
                                } else {
                                    storedRSVP?.status = statusValue
                                    storedRSVP?.saveInBackground()
                                }
                                self.parentController.fetch()
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
        }
    }
}
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
    
    var eventTitle: String? = nil
    var eventDescription: String? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(eventTitle: String) {
        self.eventTitle = eventTitle
        self.eventDescription = "This is a test event"
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
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
        let eventTitleLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 80,80,200,80))
        eventTitleLabel.text = self.eventTitle
        eventTitleLabel.textAlignment = .Center;
        eventTitleLabel.lineBreakMode = .ByWordWrapping;
        eventTitleLabel.numberOfLines = 0;
        eventTitleLabel.sizeToFit();
        self.view.addSubview(eventTitleLabel)
        
        // This block handles the description
        let eventDetailsBox = UIView(frame: CGRectMake(20, 140, self.view.frame.width-40, 100))
        eventDetailsBox.backgroundColor = UIColor.lightGrayColor()
        eventDetailsBox.layer.cornerRadius = 30.0
        
        let eventDetailsLabel = UILabel(frame: CGRectMake(25,15,200,80))
        eventDetailsLabel.text = "good Morning"
        eventDetailsLabel.textColor = UIColor.whiteColor()
        eventDetailsLabel.textAlignment = .Center;
        eventDetailsLabel.lineBreakMode = .ByWordWrapping;
        eventDetailsLabel.numberOfLines = 0;
        eventDetailsLabel.sizeToFit();
        eventDetailsBox.addSubview(eventDetailsLabel)
        self.view.addSubview(eventDetailsBox)
        
        // This block handles the FB icon (if it is a FB Event)
        var imageView = UIImageView(frame: CGRectMake(self.view.frame.width/8 - 20, 75, 40, 40));
        var image = UIImage(named: "facebook-icon.png");
        imageView.image = image;
        self.view.addSubview(imageView);
    }
    
    @IBAction func close(sender: AnyObject) {
        let nextController = ViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
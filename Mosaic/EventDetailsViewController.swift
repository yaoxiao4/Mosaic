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
        let eventTitleLabel = UILabel(frame: CGRectMake(150,75,200,40))
        eventTitleLabel.text = self.eventTitle
        self.view.addSubview(eventTitleLabel)
    }
    
    @IBAction func close(sender: AnyObject) {
        let nextController = ViewController()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
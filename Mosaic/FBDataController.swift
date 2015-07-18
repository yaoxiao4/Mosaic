//
//  FBDataController.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 7/17/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import UIKit

class FBDataController {
    
    func getEvents() {
        
        let eventRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/events", parameters: nil)
        eventRequest.startWithCompletionHandler({ (conn: FBSDKGraphRequestConnection!, eventResult: AnyObject!, err: NSError!) -> Void in
            
            if (err != nil) {
                println("Couldn't fetch events info")
                println("Error: \(err)")
            } else {
                println("here")
                var events = eventResult.valueForKey("data") as! NSArray
                println(events.count)
            }
            
        })
    }
 
}

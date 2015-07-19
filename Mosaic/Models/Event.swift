//
//  Event.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 6/10/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Parse

class Event: PFObject, PFSubclassing {
    
    @NSManaged var title : String
    @NSManaged var details: String
    @NSManaged var fb_id: String
    @NSManaged var location: Location?
    @NSManaged var added_by: PFUser?
    @NSManaged var weather: Int
    @NSManaged var picture_url: String
    @NSManaged var date: NSDate
    @NSManaged var hasStartDate: Bool
    @NSManaged var isUWEvent: Bool
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static  func parseClassName() -> String {
        return "Event"
    }
    
}
//
//  RSVP.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 6/12/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Parse

class RSVP: PFObject, PFSubclassing {
    
    @NSManaged var event : Event
    @NSManaged var user: PFObject
    @NSManaged var status: Int // 1 - Attending, 2 - Decline, 3 - Maybe
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static  func parseClassName() -> String {
        return "RSVP"
    }
    
}

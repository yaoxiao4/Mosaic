//
//  User.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 6/10/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//


import Parse

class User: PFUser, PFSubclassing {
    
    @NSManaged var usertype: Int
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}

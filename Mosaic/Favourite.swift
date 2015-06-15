//
//  Favourites.swift
//  Mosaic
//
//  Created by Renato Fernandes on 2015-06-12.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Parse

class Favourite: PFObject, PFSubclassing {
    
    @NSManaged var event: Event
    @NSManaged var user: PFObject
    @NSManaged var isFavourite: Bool
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static  func parseClassName() -> String {
        return "Favourite"
    }
    
}

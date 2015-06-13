//
//  Location.swift
//  Mosaic
//
//  Created by Yao Xiao on 2015-06-11.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation
import Parse

class Location: PFObject, PFSubclassing{
    @NSManaged var name: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var longitude: CLLocationDegrees
    @NSManaged var latitude: CLLocationDegrees
    
    override init(){
        super.init();
    }
    
    init(name: String, city: String, country: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees){
        super.init();
        self.name = name
        self.city = city
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(name: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees){
        super.init();
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Location"
    }
    
}

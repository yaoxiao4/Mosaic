//
//  UWOpenDataAPIManager.swift
//  Mosaic
//
//  Created by Renato Fernandes on 2015-07-14.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class UWOpenDataAPIManager : NSObject {
    
    static let sharedInstance = UWOpenDataAPIManager()
    
    let baseURL = "https://api.uwaterloo.ca/v2/events.json?key=30d57450aff6393d2fd6a4efabaef581"
    
    func getEvents(onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, error)
        })
        task.resume()
    }
}
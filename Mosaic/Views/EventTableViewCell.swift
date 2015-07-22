//
//  EventTableViewCell.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 6/10/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit
import Foundation

struct GlobalVariables {
    static var fbID: String?
    static var imageCache = [String:UIImage]()
    static var firstName:String?
    static var lastName:String?
    static var picture: UIImage?
    static var usertype: Int = 1
}

class EventTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var info: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithEvent(event: Event) {
        self.title.text = event.title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.info.text = "\(dateFormatter.stringFromDate(event.date))"
        self.location.text = event.location?.name
        self.location.font = UIFont(name:"HelveticaNeue-Italic", size: 12)
        
        if (event.picture_url != "") {
            let coverURL = NSURL(string: event.picture_url)
            
            // If this image is already cached, don't re-download
            if let img = GlobalVariables.imageCache[event.picture_url] {
                self.thumbnail.image = img
            }
            else {
                // The image isn't cached, download the img data
                // We should perform this in a background thread
                let request: NSURLRequest = NSURLRequest(URL: coverURL!)
                let mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data)
                        // Store the image in to our cache
                        GlobalVariables.imageCache[event.picture_url] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            self.thumbnail.image = image
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            }
            
            self.thumbnail.contentMode = .ScaleAspectFit

        }
        
    }
    
    func configureJsonEvent(event: JSON){
        let calendar = NSCalendar.currentCalendar()
        let today = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss";
        for (var a = 0; a <  event["times"].count; a++){
            let dateString = event["times"][a]["start"].string!
            
            let date = dateString.substringWithRange(Range(start: dateString.startIndex,
                end: advance(dateString.startIndex, 19)))
            var realDate = dateFormatter.dateFromString(date)!
            if (today?.compare(realDate) == NSComparisonResult.OrderedAscending){
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                self.info.text = "\(dateFormatter.stringFromDate(realDate))"
                break;
            }
        }
        
        self.location.text = event["site_name"].string
        self.location.font = UIFont(name:"HelveticaNeue-Italic", size: 12)
        self.thumbnail.image =  UIImage(named: "uwlogo_20.png");
        var s = event["title"].string as String?
        var s1 = s?.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var s2 = s1?.stringByReplacingOccurrencesOfString("&quot;", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var s3 = s2?.stringByReplacingOccurrencesOfString("&amp;", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.title.text = s3
        
    }
    
}

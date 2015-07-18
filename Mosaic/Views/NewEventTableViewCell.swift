//
//  NewEventTableViewCell.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 7/18/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit

class NewEventTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addRemoveBtn: UIButton!
    
    var event: Event!
    var status: String!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithEvent(event: Event, status: String) {
        self.event = event
        self.status = status
        
        self.titleLabel.text = event.title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.locationLabel.text = "\(dateFormatter.stringFromDate(event.date))"
        self.dateLabel.hidden = true
        
        self.addRemoveBtn.setTitle("Add", forState: .Normal)
        self.addRemoveBtn.setTitle("Adding", forState: UIControlState.Selected)
        self.addRemoveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.addRemoveBtn.addTarget(self, action: "addEvent:", forControlEvents: .TouchUpInside)
        
    }
    
    @IBAction func addEvent(sender: UIButton) {
        event.saveInBackground()
        var rsvp = RSVP()
        rsvp.user = PFUser.currentUser()!
        rsvp.event = self.event
        if (self.status == "attending") {
            rsvp.status = 1
        } else {
            rsvp.status = 3
        }
        
        rsvp.saveInBackground()
        self.addRemoveBtn.hidden = true
        self.dateLabel.hidden = false
        self.dateLabel.text = "Added Successfully!"
        self.dateLabel.textColor = UIColor.blueColor()
    }
    
}

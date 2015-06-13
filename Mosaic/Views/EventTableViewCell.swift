//
//  EventTableViewCell.swift
//  Mosaic
//
//  Created by Jal Jalali Ekram on 6/10/15.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit
import Foundation

class EventTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithEvent(event: Event)->Void {
        self.title.text = event.title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
//        TODO: Add location later
        self.info.text = "\(dateFormatter.stringFromDate(event.date)) at \(event.location!.name)"
        
    }
    
}

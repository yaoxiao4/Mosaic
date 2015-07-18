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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithEvent(event: Event) {
        self.titleLabel.text = event.title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.locationLabel.text = "\(dateFormatter.stringFromDate(event.date))"
        self.dateLabel.hidden = true
        
        
//        self.addRemoveBtn.backgroundColor = UIColor.redColor()
        
    }
    
}

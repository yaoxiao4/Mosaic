//
//  SettingsViewController.swift
//  Mosaic
//
//  Created by Ali on 2015-06-14.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.view.backgroundColor = UIColor.whiteColor()

        var profileImageView = UIImageView(frame: CGRectMake(25, 80, 150, 150))
        profileImageView.contentMode = .ScaleAspectFit
        
//        profileImageView.layer.cornerRadius =  profileImageView.frame.size.height / 2
//        profileImageView.clipsToBounds = true
        
        profileImageView.image = GlobalVariables.picture
        self.view.addSubview(profileImageView)
    }
}

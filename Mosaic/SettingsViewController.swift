//
//  SettingsViewController.swift
//  Mosaic
//
//  Created by Ali on 2015-06-14.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.tabBarController?.tabBar.hidden = true

        var profileImageView = UIImageView(frame: CGRectMake(20, 100, 150, 150))
        profileImageView.contentMode = .ScaleAspectFit
        
        //profileImageView.layer.cornerRadius =  profileImageView.frame.size.height / 2
        //profileImageView.clipsToBounds = true
        
        profileImageView.image = GlobalVariables.picture
        self.view.addSubview(profileImageView)
        
        // First Name Label
        var firstNameLabel = UILabel(frame: CGRectMake(175, 140, 180, 40))
        firstNameLabel.text = GlobalVariables.firstName! + " " + GlobalVariables.lastName!
        firstNameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        firstNameLabel.textColor = UIColor.blackColor()
        self.view.addSubview(firstNameLabel)
        // End First Name Label
        
        // Last Name Label
        var lastNameLabel = UILabel(frame: CGRectMake(175, 170, 190, 40))
        lastNameLabel.text = "ravanchi@hotmail.com"
        lastNameLabel.font = UIFont(name:"HelveticaNeue", size: 17.0)
        lastNameLabel.textColor = UIColor.blackColor()
        self.view.addSubview(lastNameLabel)
        // End Last Name Label
        
        // Sign In Button
        let signInButton = FBSDKLoginButton(frame: CGRectMake(100, 200, 200, 50))
        signInButton.center = self.view.center
        self.view.addSubview(signInButton)
        
        signInButton.delegate = self
        // End Sign In Button
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    override func viewWillDisappear(animated:Bool) {
        if (self.navigationController?.topViewController is ViewController){
            var controller = self.navigationController?.topViewController as! ViewController
            self.tabBarController?.tabBar.hidden = false
            //controller.fetch()
        }
        
        super.viewWillDisappear(animated)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let loginViewController = LoginViewController()
        
        PFUser.logOut()
        
        //let viewController = ViewController()
        //let navigationController = UINavigationController(rootViewController: loginViewController)
        //navigationController.navigationBar.backgroundColor = UIColor.blueColor()
        let currentUser: PFUser? = PFUser.currentUser()
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        self.window?.rootViewController = loginViewController

        presentViewController(navigationController, animated: true, completion: nil)
        println("User Logged Out")
    }
}

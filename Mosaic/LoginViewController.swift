//
//  LoginViewController.swift
//  Mosaic
//
//  Created by Ali on 2015-06-12.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var debugLabel: UILabel!
    var window: UIWindow?
    let permissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        let currentUser: PFUser? = PFUser.currentUser()
        super.viewDidLoad()
        if(currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser!)) {
            self.loginSuccessful()
        }
        
        self.view.backgroundColor = UIColor.grayColor()
        
        var label = UILabel(frame: CGRectMake(0, 0, 200, 25))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Mosaic"
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
        
        let signInButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        signInButton.frame = CGRectMake(100, 100, 200, 50)
        signInButton.backgroundColor = UIColor.blueColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signInButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        signInButton.addTarget(self, action: "fbLoginClick:", forControlEvents: UIControlEvents.TouchUpInside)
        signInButton.center = self.view.center
        
        self.view.addSubview(signInButton)
    }
    
    func fbLoginClick(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(self.permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user == nil {
                NSLog("The user cancelled the Facebook login.")
            } else if user!.isNew {
                NSLog("User signed up and logged in through Facebook!")
                self.loginSuccessful()
            } else {
                NSLog("User logged in through Facebook! \(user!.username)")
                self.loginSuccessful()
            }
        })
    }
    
    func getUserInfo() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if error != nil {
                    println("facebook request was null")
                } else {
                    let fbID = result.valueForKey("id") as? String
                    let urlUserImg = "http://graph.facebook.com/" + fbID! + "/picture?type=large"
                    let firstName = result.valueForKey("first_name") as? String
                    let lastName = result.valueForKey("last_name") as? String
                    NSLog(firstName!)
                    NSLog(lastName!)
                    NSLog(urlUserImg)
                }
        })
    }
    
    func loginSuccessful() {
        self.getUserInfo()
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
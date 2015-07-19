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
    let permissions = ["public_profile", "email", "user_friends", "user_events"]
    
    override func viewDidLoad() {
        let currentUser: PFUser? = PFUser.currentUser()
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let signInButton = FBSDKLoginButton(frame: CGRectMake(100, 200, 200, 50))
        signInButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)

        // Title Label
        var titleLabel = UILabel(frame: CGRectMake(0, 200, self.view.frame.width, 40))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "Mosaic"
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 40.0)
        titleLabel.textColor = UIColor.blackColor()
        self.view.addSubview(titleLabel)
        // End Title Label

        // Sign In Button
        signInButton.frame = CGRectMake(100, 100, 200, 50)
        signInButton.backgroundColor = UIColor.blueColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signInButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        signInButton.addTarget(self, action: "fbLoginClick:", forControlEvents: UIControlEvents.TouchUpInside)
        signInButton.center = self.view.center
        self.view.addSubview(signInButton)
        // End Sign In Button
    }
    
    func fbLoginClick(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(self.permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                if user!.isNew {
                    NSLog("User signed up and logged in through Facebook!")
                } else {
                    NSLog("User logged in through Facebook! \(user!.username)")
                }
                self.loginSuccessful()
            } else {
                NSLog("The user cancelled the Facebook login.")
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
                    
                    GlobalVariables.fbID = result.valueForKey("id") as? String
                    GlobalVariables.firstName = firstName
                    GlobalVariables.lastName = lastName
                    let coverURL = NSURL(string: urlUserImg)
                    let data = NSData(contentsOfURL: coverURL!)
                    let image = UIImage(data: data!)
                    GlobalVariables.picture = image
                    
                    NSLog(firstName!)
                    NSLog(lastName!)
                    NSLog(urlUserImg)
                }
        })
    }
    
    func loginSuccessful() {
        self.getUserInfo()
        
        let tabBarController = UITabBarController()
        let currentUser: PFUser? = PFUser.currentUser()
        var usertype = currentUser?.objectForKey("usertype") as! Int
        GlobalVariables.usertype = usertype
        
        let viewController = ViewController(isSegment: true, viewTitle: "Events")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
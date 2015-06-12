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
    }
    
    @IBAction func fbLoginClick(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(self.permissions, /*block; added*/block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
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
                    println(firstName)
                    println(lastName)
                    println(urlUserImg)
                }
        })
    }
    
    func loginSuccessful() {
        self.getUserInfo()
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let tabBarController = UITabBarController()
        let viewController = ViewController()
        let favController = FavouriteController()
        let attendingController = AttendingController()
        let navigationController1 = UINavigationController(rootViewController: viewController)
        let navigationController2 = UINavigationController(rootViewController: favController)
        let navigationController3 = UINavigationController(rootViewController: attendingController)
        
        navigationController1.tabBarItem.image = UIImage(named: "Home-25")
        navigationController2.tabBarItem.image = UIImage(named: "Star-25")
        navigationController3.tabBarItem.image = UIImage(named: "Checkmark-25")
        
        viewController.title = "Home"
        favController.title = "Favourites"
        attendingController.title = "Attending"
        tabBarController.viewControllers = [navigationController1, navigationController2, navigationController3]
        
        presentViewController(tabBarController, animated: true, completion: nil)

    }

}
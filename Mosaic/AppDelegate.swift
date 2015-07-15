//
//  AppDelegate.swift
//  Mosaic
//
//  Created by Ali on 2015-05-25.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import UIKit
import Parse
import Bolts
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyCwG0yXlBE_2t218SRoc2iUvJgjOALo1OQ"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("yD550wqf0ibmwSZfNT3kor0PdoWai5jYV4jmmnpa",
            clientKey: "hxEcfQ6ZFwHokzZJcTpcY67QsLFs6ezQaFNXkONA")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let loginViewController = LoginViewController()
        let currentUser: PFUser? = PFUser.currentUser()
        var usertype = currentUser?.objectForKey("usertype") as! Int
        GlobalVariables.usertype = usertype
        
        if(currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser!)) {
            loginViewController.getUserInfo()
            if (usertype == 2){
                let viewController = ViewController(isSegment: true, viewTitle: "Events")
                let navigationController = UINavigationController(rootViewController: viewController)
                
                self.window?.rootViewController = navigationController
            } else if (usertype == 1){
                let viewController = ViewController(isSegment: true, viewTitle: "Events")
                let navigationController = UINavigationController(rootViewController: viewController)
                
                self.window?.rootViewController = navigationController
            }
            
        } else {
            self.window?.rootViewController = loginViewController
        }
 
        self.window?.makeKeyAndVisible()
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    
}


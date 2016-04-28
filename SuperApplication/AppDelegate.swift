//
//  AppDelegate.swift
//  SuperApplication
//
//  Created by Филипп Белов on 4/27/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Get the time when the weather was last updated
        guard let lastUpdated = NSUserDefaults.standardUserDefaults().valueForKey("LastUpdated") as? NSDate else { return }
        
        // If the time since a user left the app is more than 30 seconds, then perform an update
        if NSDate().timeIntervalSinceDate(lastUpdated) > 30 {
            // Get ViewController
            let vc = self.window!.rootViewController as! ViewController
            // Perform an update
            vc.performUpdate()
        }
    }

}
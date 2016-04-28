//
//  ViewController.swift
//  SuperApplication
//
//  Created by Филипп Белов on 4/27/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

    // MARK: Properties
    var locationManager : CLLocationManager!
    var currentWeather : Weather! {
        didSet {
            // Using dispatch_async in order to not block the interactions with the UI. Although it's not necessary in this small app, it's a nice addition
            dispatch_async(dispatch_get_main_queue(), {
                self.updateInfo()
                self.updateButton.enabled = true
            })
        }
    }
    
    // MARK: Standard Stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Playing Refresh Animation because we're updating our app when the view is loaded
        self.playRefreshAnimation()
        
        self.setupUI()
        // initializing location manager, from which the requestLocation method is called which leads to the update process of the weather
        self.initLocationManager()
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UI Setup
    func setupUI() {
        // Background
        var gradientLayer : CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        let colorSet = [UIColor(red:47/255, green:225/255, blue:253/255, alpha:1.0).CGColor, UIColor(red:242/255, green:106/255, blue:255/255, alpha:1.0).CGColor]
        gradientLayer.colors = colorSet
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    func playRefreshAnimation() {
        let duration = 1.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced.union(UIViewKeyframeAnimationOptions.Repeat)
        let fullRotation = CGFloat(M_PI * 2)

        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.updateButton.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.updateButton.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.updateButton.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })
            
            }, completion: nil)

    }
    
    // MARK: IB
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBAction func updateWeather(sender: UIButton) {
        self.performUpdate()
    }
    
    // MARK: Updating
    func performUpdate() {
        print("I was called")
        self.updateButton.enabled = false
        self.playRefreshAnimation()
        self.locationManager.requestLocation()
    }
    func updateInfo() {
        temperatureLabel.text = String(Int(currentWeather.temp!)).uppercaseString + "°"
        locationLabel.text = self.currentWeather.place?.city?.uppercaseString
        maxTempLabel.text = String(Int(self.currentWeather.maxTemp!)).uppercaseString + "°"
        minTempLabel.text = String(Int(self.currentWeather.minTemp!)).uppercaseString + "°"
    }
    
}

// MARK: CLLocationDelegate
extension ViewController : CLLocationManagerDelegate {
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.requestLocation()
            break
        default:
            break
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // using guard in order to prevent cases when the determinedLocation is nil
        guard let determinedLocation = locations.first else { return }
        
        // Using WeatherAPI singleton to perform an API call.
        WeatherAPI.sharedInstance.getCurrentWeatherForLocation(determinedLocation, completion: { (weather : Weather?) in
            // Preventing the cases when weather is nil
            guard let newWeather = weather else { return }
            // Stopping the update animation
            dispatch_async(dispatch_get_main_queue(), {
                self.updateButton.layer.removeAllAnimations()
            })
            // setting the current weather to newly updated weather that we got from API request
            self.currentWeather = newWeather
            // updating the time when the weather was last updated
            NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: "LastUpdated")
            print(NSUserDefaults.standardUserDefaults().valueForKey("LastUpdated"))
        })
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error >> \(error.description)")
    }
    
    // Implementation of the didChangeAuthorization status of CLLocationDelegate method. We do it because a user could've not granted access to his location.
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            // if the access is granted, request a location
            manager.requestLocation()
            break
        case .NotDetermined:
            // Request 'WhenInUseAuthorization' because we need to track user's location only when he's using the app. However, if we'd needed to send him push notifications about tomorrow weather, we'd need to be always authorized
            manager.requestWhenInUseAuthorization()
            break
        case .Restricted, .Denied:
            // Try to make user grant us a location access
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get weather for your current location, please, open this app's setting and set location acess to 'When in use'. Thank you :)",
                preferredStyle: .Alert
            )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default, handler: { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        }
    }
}



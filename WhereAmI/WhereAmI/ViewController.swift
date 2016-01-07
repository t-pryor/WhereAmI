//
//  ViewController.swift
//  WhereAmI
//
//  Created by Tim Pryor on 2016-01-04.
//  Copyright © 2016 Tim Pryor. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    // will keep track of the location from the last update we received from the location manaager
    private var previousPoint: CLLocation?
    // each time user moves far enough to trigger an update, will be ablet to add the latest movement distance to our running total
    private var totalMovementDistance: CLLocationDistance = 0
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    @IBOutlet var altitudeLabel:UILabel!
    @IBOutlet var verticalAccuracyLabel: UILabel!
    @IBOutlet var distanceTraveledLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // in real app should delay making request until you actually need to use location services
        locationManager.requestWhenInUseAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // AFTER AUTHORIZATION
    // at some point after viewDidLoad() returns, this function is called
    // the user can give your application permission to use Core Location and then later revoke it-then need to stop listening for updates
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        
        
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let errorType = error.code == CLError.Denied.rawValue ? "Access Denied": "Error \(error.code)"
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in })
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations could contain more than one location update, but last always represents most re
        if let newLocation = locations.last {
            // update first five labels 
            // both longitude and latitude displayed in formatting strings containg hex value of Unicode representation of degree symbol
            let latitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.latitude)
            latitudeLabel.text = latitudeString
            
            let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
            longitudeLabel.text = longitudeString
            
            let horizontalAccuracyString = String(format:"%gm", newLocation.horizontalAccuracy)
            horizontalAccuracyLabel.text = horizontalAccuracyString
            
            let altitudeString = String(format: "%gm", newLocation.altitude)
            altitudeLabel.text = altitudeString
            
            let verticalAccuracyString = String(format: "%gm", newLocation.verticalAccuracy)
            verticalAccuracyLabel.text = verticalAccuracyString
            
            
            // check accuracy of values location manager gives nus
            // high accuracy values indicate that the location manager isn't quite sure about the application, negative values-location invalid
            //
            
            
            if newLocation.horizontalAccuracy < 0 {
                // invalid accuracy
                return
            }
            
            // numbers in meters
            if newLocation.horizontalAccuracy > 100 ||
                newLocation.verticalAccuracy > 50 {
                    // accuracy radius is so large, we don't want to use it
                    return
            }
            
            // if nil, this update is the first valid one gotten from the location manager, so zero out distanceFromStart
            if previousPoint == nil {
                totalMovementDistance = 0
            } else {
                print("movement distance: " +
                "\(newLocation.distanceFromLocation(previousPoint!))")
                totalMovementDistance += newLocation.distanceFromLocation(previousPoint!)
            }
            previousPoint = newLocation
            
            let distanceString = String(format: "%gm", totalMovementDistance)
            distanceTraveledLabel.text = distanceString
        }
        
        
    }

    
}


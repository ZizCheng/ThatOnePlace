//
//  EntryVC.swift
//  That One Place
//
//  Created by Zizheng Cheng on 5/11/18.
//  Copyright © 2018 That One Place. All rights reserved.
//

import UIKit
import CoreLocation
import DeviceCheck

class EntryVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var discoverButton: UIButton!
    
    var locationManager = CLLocationManager()
    var latitude = "32.1"
    var longitude = "-122.58"
    
    var auth: Auth?
    var finder: RestaurantFinder?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        auth = Auth.init(u: UIDevice.current.identifierForVendor!.uuidString)
        finder = RestaurantFinder.init(Latitude: self.latitude, Longitude: self.longitude, auth: self.auth!)
        authenticate(auth!)
        determineMyCurrentLocation()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let waitvc = segue.destination as! WaitVC
        waitvc.finder = self.finder!
        waitvc.totalTime = self.auth!.Profile!.time!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

    @IBAction func DiscoverClicked(_ sender: UIButton)
    {
        if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
        {
            if(self.auth!.time <= 0){
                
                finder?.getOne(completion: { restaurant in
                    
                })
            }
            self.performSegue(withIdentifier: "wait", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "You are retarded", message: "go allow location services", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "NANI", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Shit fam my bad", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        finder!.Latitude = "" + "\(userLocation.coordinate.latitude)"
        finder!.Longtitude = "" + "\(userLocation.coordinate.longitude)"
        manager.stopUpdatingLocation()
        
    }
    
    func authenticate(_ Authentication: Auth) -> Void {
        if(isAppAlreadyLaunchedOnce())
        {
            Authentication.login()
        }
        else
        {
            Authentication.register()
            Authentication.login()
        }
    }
}

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
        // Do any additional setup after loading the view, typically from a nib.
        /*var token: String?
        let curDevice = DCDevice.current
        if curDevice.isSupported
        {
            curDevice.generateToken(completionHandler: { (data, error) in
                if let tokenData = data
                {
                    print("Received token \(tokenData)")
                    token = String(decoding: data!, as: UTF8.self)
                }
                else
                {
                    print("Hit error: \(error!.localizedDescription)")
                }
            })
        }*/
        
        auth = Auth.init(u: UIDevice.current.identifierForVendor!.uuidString)
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    
    }
    
    func theRest()
    {
        if(isAppAlreadyLaunchedOnce())
        {
            let t = getTimeRemaining()
            print(t)
            if(t > 0)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WVC") as! WaitVC
                vc.finder = self.finder
                vc.totalTime = t
                self.present(vc, animated: false, completion: nil)
            }
            else
            {
                let btnImage = UIImage(named: "Discover1")
                discoverButton.setImage(btnImage , for: UIControlState.normal)
                discoverButton.imageView?.contentMode = .scaleAspectFit
            }
        }
        else
        {
            register()
            
            let btnImage = UIImage(named: "Discover1")
            discoverButton.setImage(btnImage , for: UIControlState.normal)
            discoverButton.imageView?.contentMode = .scaleAspectFit
            auth?.login()
        }
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
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WVC") as! WaitVC
            vc.finder = self.finder
            //code for restaurant requesting goes here
            finder?.getOne(completion: {restaurant in
                self.finder?.restaurant = restaurant
                print(self.finder?.restaurant?.name)
            })
            //assign vc.finder to be the new finder with a restaurant attached
            self.present(vc, animated: false, completion: nil)
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
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        self.latitude = "" + "\(userLocation.coordinate.latitude)"
        self.longitude = "" + "\(userLocation.coordinate.longitude)"
        manager.stopUpdatingLocation()
        
        finder = RestaurantFinder.init(Latitude: self.latitude, Longitude: self.longitude, auth: self.auth!)
        
        theRest()
    }
    
    
    
    
    func getTimeRemaining() -> Int
    {
        return (auth?.login().profile?.time!)!
    }
    
    func register()
    {
        auth?.register()
    }
    
}

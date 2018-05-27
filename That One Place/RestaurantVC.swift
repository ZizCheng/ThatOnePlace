//
//  RestaurantVC.swift
//  That One Place
//
//  Created by Zizheng Cheng on 5/20/18.
//  Copyright © 2018 That One Place. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RestaurantVC: UIViewController
{
    var restaurantFinder: RestaurantFinder?
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPriceLabel: UILabel!
    @IBOutlet weak var restaurantMapView: MKMapView!
    @objc override func viewDidLoad()
    {
        super.viewDidLoad()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        self.restaurantFinder!.restaurant!.fetchImage(completion: {image in
            DispatchQueue.main.async {
                self.restaurantImage.image = image
            }
        })
        
        restaurantNameLabel.text = restaurantFinder?.restaurant?.name
        restaurantPriceLabel.text = restaurantFinder?.restaurant?.price
        
        setMap()
    }
    
    func setMap()
    {
        let longDouble = Double(self.restaurantFinder!.restaurant!.coordinates.longitude!)
        let latDouble = Double(self.restaurantFinder!.restaurant!.coordinates.latitude!)
        
        let initialLocation = CLLocation(latitude: latDouble, longitude: longDouble)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        restaurantMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        print("got in #1")
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("got in #2")
                self.dismiss(animated: true, completion: nil)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}

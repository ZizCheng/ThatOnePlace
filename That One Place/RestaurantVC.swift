//
//  RestaurantVC.swift
//  That One Place
//
//  Created by Zizheng Cheng on 5/20/18.
//  Copyright © 2018 That One Place. All rights reserved.
//

import Foundation
import UIKit

class RestaurantVC: UIViewController
{
    var restaurant: Restaurant?
    
    @objc override func viewDidLoad()
    {
        super.viewDidLoad()
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
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

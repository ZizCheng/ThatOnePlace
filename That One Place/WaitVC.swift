//
//  WaitVC.swift
//  That One Place
//
//  Created by Zizheng Cheng on 5/11/18.
//  Copyright © 2018 That One Place. All rights reserved.
//

import UIKit

class WaitVC: UIViewController {
    
    @IBOutlet weak var waitButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var countdownTimer: Timer!
    var totalTime = 14399
    
    var finder: RestaurantFinder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitButton.imageView?.contentMode = .scaleAspectFit
        totalTime = finder!.auth.time
        startTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
    }
    
    
}

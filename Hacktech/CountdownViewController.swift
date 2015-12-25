//
//  FirstViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/14/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    // Countdown UILabel
    @IBOutlet var label:UILabel! {
        didSet {
            label.font = label.font.monospacedDigitFont
        }
    }
    @IBOutlet var countdownRing:KDCircularProgress!
    
    // End time of hackathon, format is "yyyy/MM/dd HH:mm zz"
    let endTimeString = "2016/02/27 00:00 PST"
    
    // Duration of hackathon, in hours
    let duration = 36
    
    let minutesInHour = 60
    let secondsInMinute = 60
    
    // NSDate Object of end time
    let endTime : NSDate!
    
    // NSTimer to continuously update timer
    var timer = NSTimer()
    
    // Colors
    let orange = UIColor(red: 244/255.0, green: 132/255.0, blue: 48/255.0, alpha: 1.0)
    let gray = UIColor(red: 61/255.0, green: 58/255.0, blue: 58/255.0, alpha: 1.0)
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init(_ coder: NSCoder? = nil) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm zz"
        
        endTime = dateFormatter.dateFromString(endTimeString)!
        
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial countdown text
        label.text = "36 : 00 : 00"
        
        
        // Set ring UI settings
        
        countdownRing.startAngle = -90
        countdownRing.progressThickness = 0.2
        countdownRing.trackThickness = 0.22
        countdownRing.clockwise = false
        countdownRing.gradientRotateSpeed = 2
        countdownRing.roundedCorners = false
        countdownRing.glowMode = .Constant
        countdownRing.glowAmount = 0.3
        countdownRing.setColors(orange)
        countdownRing.trackColor = gray
        countdownRing.angle = 360
        
        // Update text and ring UI
        updateTime()
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Updates the time shown and the ring UI progress
    func updateTime() {
        var timeLeft = Int(ceil(endTime.timeIntervalSinceDate(NSDate())))
        if (timeLeft <= 0) {
            label.text = "00 : 00 : 00"
            countdownRing.angle = 0
            timer.invalidate()
        }
        else if (timeLeft <= duration * minutesInHour * secondsInMinute) {
            // Set angle of ring UI = fraction of time left * 360.0
            countdownRing.angle = Int(Float(timeLeft) / Float(duration * minutesInHour * secondsInMinute) * 360.0)
            
            // Set countdown text by calculating hours, minutes, and seconds
            let hours = timeLeft / (minutesInHour * secondsInMinute)
            timeLeft -= hours * (minutesInHour * secondsInMinute)
            
            let minutes = timeLeft / (secondsInMinute)
            timeLeft -= minutes * (secondsInMinute)
            
            let seconds = timeLeft
            
            label.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        }
    }
}
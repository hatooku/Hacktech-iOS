//
//  FirstViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/14/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController {

    // Countdown UILabel
    @IBOutlet var label:UILabel!
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        label.text = "36:00:00"
        updateTime()
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTime() {
        var timeLeft = Int(ceil(endTime.timeIntervalSinceDate(NSDate())))
        if (timeLeft <= 0) {
            label.text = "00:00:00"
            timer.invalidate()
        }
        else if (timeLeft <= duration * minutesInHour * secondsInMinute) {
            let hours = timeLeft / (minutesInHour * secondsInMinute)
            timeLeft -= hours * (minutesInHour * secondsInMinute)
            
            let minutes = timeLeft / (secondsInMinute)
            timeLeft -= minutes * (secondsInMinute)
            
            let seconds = timeLeft
            
            label.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
//
//  EventViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/29/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var titleString: String!
    var locationString: String!
    var descriptionString: String!
    var startTime: NSDate!
    var durationInHours: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString
        locationLabel.text = locationString
        descriptionLabel.text = descriptionString
        
        let dateIntervalFormatter = NSDateIntervalFormatter()
        
        dateIntervalFormatter.dateTemplate = "EEEEddMMMM h:mm a"
        
        let endTime = startTime.dateByAddingTimeInterval(60 * 60 * durationInHours!)
        
        timeLabel.text = dateIntervalFormatter.stringFromDate(startTime, toDate: endTime)
        
    }

}

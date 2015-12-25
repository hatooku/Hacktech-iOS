//
//  SecondViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/14/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

struct activity {
    let time : String
    let event : String
}

let day1 = [activity(time: "12:00 AM", event: "KICKOFF"), activity(time: "01:00 AM", event: "HACKING BEGINS"),
    activity(time: "03:00 AM", event: "FOOD TRUCK ROLLS IN"), activity(time: "04:00 AM", event: "KRISPY KREME")]

let day2 = [activity(time: "02:00 PM", event: "LUNCH"), activity(time: "04:00 PM", event: "SNACKS"),
    activity(time: "06:00 PM", event: "DINNER"), activity(time: "08:00 PM", event: "MORE HACKING")]

let day3 = [activity(time: "02:00 AM", event: "BOBA"), activity(time: "08:00 AM", event: "GET READY FOR PRESENTATIONS"),
    activity(time: "10:00 AM", event: "PRESENTATIONS"), activity(time: "12:00 PM", event: "END")]

let eventArr = [day1, day2, day3]


class ScheduleViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventArr.count
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArr[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! ScheduleCell
        
        cell.timeLabel.text = eventArr[indexPath.section][indexPath.row].time
        cell.eventLabel.text = eventArr[indexPath.section][indexPath.row].event

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier("ScheduleHeader") as! ScheduleHeader
        headerCell.dayLabel.text = "Day " + String(section + 1)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(46)
    }

}


//
//  Announcements.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/30/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AnnouncementsViewController: PFQueryTableViewController {
    
    let dateFormatter = NSDateFormatter()
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Announcements"
        self.textKey = "Title"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        
        dateFormatter.dateFormat =  "EEE hh:mm a"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "PST")
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Announcements")
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("Announcements Cell", forIndexPath: indexPath) as! AnnouncementsCell
        
        if let titleText = object?["Title"] as? String {
            cell.titleLabel.text = titleText
        }
        else {
            cell.titleLabel.text = ""
        }
        
        if let descriptionText = object?["Description"] as? String {
            cell.descriptionLabel.text = descriptionText
        }
        else {
            cell.descriptionLabel.text = ""
        }
        
        if let creationTime = object?.createdAt {
            cell.timeLabel.text = dateFormatter.stringFromDate(creationTime)
        }
        else {
            cell.timeLabel.text = ""
        }
        return cell
    }
}

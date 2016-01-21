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
    
    var shouldUpdateFromServer:Bool = true
    
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
        
        // refresh objects when app becomes active
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshObjects"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Refresh objects if needed
        refreshObjects()
    }
    
    override func queryForTable() -> PFQuery {
        return self.baseQuery().fromLocalDatastore()
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
        cell.sizeToFit()
        
        return cell
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        // If we just updated from the server, do nothing, otherwise update from server.
        if self.shouldUpdateFromServer {
            self.refreshLocalDataStoreFromServer()
        } else {
            self.shouldUpdateFromServer = true
            self.updateBadge()
        }
    }
    
    func updateBadge() {
        let currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
            let announcementsTab = self.navigationController!.tabBarItem
            announcementsTab?.badgeValue = nil
        }
    }
    
    func refreshObjects() {
        let currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            self.loadObjects()
        }
    }
    
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "Announcements")
        
        // Only show objects that have been pushed (aka ready to be shown)
        // pushed == 1 or pushed == 2
        query.whereKey("pushed", containedIn: [1, 2])
        
        query.orderByDescending("createdAt")
        
        return query
    }
        
    func refreshLocalDataStoreFromServer() {
        self.baseQuery().findObjectsInBackgroundWithBlock { (parseObjects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // First, unpin all existing objects
                PFObject.unpinAllInBackground(self.objects as! [PFObject]?, block: { (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        // Pin all the new objects
                        PFObject.pinAllInBackground(parseObjects, block: { (succeeded: Bool, error: NSError?) -> Void in
                            if error == nil {
                                // Once we've updated the local datastore, update the view with local datastore
                                self.shouldUpdateFromServer = false
                                self.loadObjects()
                            }
                        })
                    }
                })
            }
        }
    }
}

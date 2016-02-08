//
//  ScheduleViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/27/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit
import Parse

let MSEventCellReuseIdentifier = "MSEventCellReuseIdentifier"
let MSDayColumnHeaderReuseIdentifier = "MSDayColumnHeaderReuseIdentifier"
let MSTimeRowHeaderReuseIdentifier = "MSTimeRowHeaderReuseIdentifier"

let MIN_PER_HOUR = 60.0
let SEC_PER_MIN = 60.0

class ScheduleViewController: UICollectionViewController, MSCollectionViewDelegateCalendarLayout {
    
    var collectionViewCalendarLayout: MSCollectionViewCalendarLayout = MSCollectionViewCalendarLayout()
    let query = PFQuery(className: "Schedule")
    var eventArr = [[MSEvent]]()
    var loading = false
    
    // variable to preserve content offset when returning from segue
    var firstAppear = true
    
    var layoutSectionWidth: CGFloat {
        get {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
                return 254.0
            }
            
            let width = CGRectGetWidth(self.collectionView!.bounds)
            let timeRowHeaderWidth = self.collectionViewCalendarLayout.timeRowHeaderWidth
            let rightMargin = self.collectionViewCalendarLayout.contentMargin.right
            
            return (width - timeRowHeaderWidth - rightMargin)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set custom layout
        self.collectionViewCalendarLayout.delegate = self
        
        self.collectionView?.collectionViewLayout = self.collectionViewCalendarLayout
        
        self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth
        
        // Register Classes
        
        self.collectionView?.registerClass(MSEventCell.self, forCellWithReuseIdentifier: MSEventCellReuseIdentifier)
        
        self.collectionView?.registerClass(MSDayColumnHeader.self, forSupplementaryViewOfKind: MSCollectionElementKindDayColumnHeader, withReuseIdentifier: MSDayColumnHeaderReuseIdentifier)
        
        self.collectionView?.registerClass(MSTimeRowHeader.self, forSupplementaryViewOfKind: MSCollectionElementKindTimeRowHeader, withReuseIdentifier: MSTimeRowHeaderReuseIdentifier)
        
        self.collectionViewCalendarLayout.registerClass(MSCurrentTimeIndicator.self, forDecorationViewOfKind: MSCollectionElementKindCurrentTimeIndicator)
        
        self.collectionViewCalendarLayout.registerClass(MSCurrentTimeGridline.self, forDecorationViewOfKind: MSCollectionElementKindCurrentTimeHorizontalGridline)
        
        self.collectionViewCalendarLayout.registerClass(MSGridline.self, forDecorationViewOfKind: MSCollectionElementKindVerticalGridline)
        
        self.collectionViewCalendarLayout.registerClass(MSGridline.self, forDecorationViewOfKind: MSCollectionElementKindHorizontalGridline)
        
        self.collectionViewCalendarLayout.registerClass(MSTimeRowHeaderBackground.self, forDecorationViewOfKind: MSCollectionElementKindTimeRowHeaderBackground)
        
        self.collectionViewCalendarLayout.registerClass(MSDayColumnHeaderBackground.self, forDecorationViewOfKind: MSCollectionElementKindDayColumnHeaderBackground)
        
        // Fill Event Array

        loadEvents()
    }
    
    // load data off plist file
    
    func loadEvents() {
        self.loading = true
        var day1 = [MSEvent]()
        var day2 = [MSEvent]()
        var day3 = [MSEvent]()
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.eventArr.removeAll()
                for object in objects! {
            
                    if object["startTime"] != nil && object["endTime"] != nil && object["title"] != nil {
                        let event = MSEvent.create()
                        let start =  (object["startTime"] as! NSDate!)
                        let end = (object["endTime"] as! NSDate!)
                        event.start = start.dateByAddingTimeInterval(8.0 * MIN_PER_HOUR * SEC_PER_MIN)
                        event.end = end.dateByAddingTimeInterval(8.0 * MIN_PER_HOUR * SEC_PER_MIN)
            
                        event.title = object["title"] as! String!
            
                        if (object["location"] != nil) {
                            event.location = object["location"] as! String!
                        }
                        else {
                            event.location = ""
                        }
            
                        if (object["description"] != nil) {
                            event.information = object["description"] as! String!
                        }
                        else {
                            event.information = ""
                        }
            
                        if let day = object["day"] as! Int? {
                            if (day == 1) {
                                day1.append(event)
                            }
                            else if (day == 2) {
                                day2.append(event)
                            }
                            else {
                                day3.append(event)
                            }
                        }
                    }
                }
                if (!day1.isEmpty) {
                    self.eventArr.append(day1)
                }
                if (!day2.isEmpty) {
                    self.eventArr.append(day2)
                }
                if (!day3.isEmpty) {
                    self.eventArr.append(day3)
                }
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionViewCalendarLayout.invalidateLayoutCache()
                self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth
                self.collectionView!.reloadData()
                self.loading = false
            }
            else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        if (!self.loading) {
            self.loadEvents()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (firstAppear) {
            self.collectionViewCalendarLayout.scrollCollectionViewToClosetSectionToCurrentTimeAnimated(true)
            firstAppear = false
        }
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // Ensure that collection view properly rotates between layouts
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionViewCalendarLayout.invalidateLayoutCache()
        
        coordinator.animateAlongsideTransition(
            { (context UIViewControllerTransitionCoordinatorContext) in
                self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth
            }, completion:
            { (context UIViewControllerTransitionCoordinatorContext) in
                self.collectionView?.reloadData()
            })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.eventArr.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventArr[section].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MSEventCellReuseIdentifier, forIndexPath: indexPath) as! MSEventCell
        
        cell.event = self.eventArr[indexPath.section][indexPath.row]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var view: UICollectionReusableView = UICollectionReusableView()
        
        if (kind == MSCollectionElementKindDayColumnHeader) {
            let dayColumnHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MSDayColumnHeaderReuseIdentifier, forIndexPath: indexPath) as! MSDayColumnHeader
            
            let day = self.collectionViewCalendarLayout.dateForDayColumnHeaderAtIndexPath(indexPath)
            
            let currentDay = self.currentTimeComponentsForCollectionView(self.collectionView!, layout: self.collectionViewCalendarLayout)
            
            let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(day)
            
            let startOfCurrentDay = NSCalendar.currentCalendar().startOfDayForDate(currentDay)
            
            dayColumnHeader.day = day
            dayColumnHeader.currentDay = startOfDay.isEqualToDate(startOfCurrentDay)
            
            view = dayColumnHeader
        }
        
        else if (kind == MSCollectionElementKindTimeRowHeader) {
            let timeRowHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MSTimeRowHeaderReuseIdentifier, forIndexPath: indexPath) as! MSTimeRowHeader
            timeRowHeader.time = self.collectionViewCalendarLayout.dateForTimeRowHeaderAtIndexPath(indexPath)
            view = timeRowHeader
        }
        return view;
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: MSCollectionViewCalendarLayout!, dayForSection section: Int) -> NSDate! {
        let day = self.eventArr[section].first!.start
        return NSCalendar.currentCalendar().startOfDayForDate(day)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: MSCollectionViewCalendarLayout!, startTimeForItemAtIndexPath indexPath: NSIndexPath!) -> NSDate! {
        let event = self.eventArr[indexPath.section][indexPath.row]
        return event.start
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: MSCollectionViewCalendarLayout!, endTimeForItemAtIndexPath indexPath: NSIndexPath!) -> NSDate! {
        let event = self.eventArr[indexPath.section][indexPath.row]
        
        return event.end.dateByAddingTimeInterval(-10)
    }
    
    func currentTimeComponentsForCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: MSCollectionViewCalendarLayout!) -> NSDate! {
        return NSDate()
    }
    
    // Setup selection
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showEvent", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEvent" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            let selectedEvent = self.eventArr[indexPath.section][indexPath.row]
            
            
            let eventViewController = segue.destinationViewController as! EventViewController
            
            eventViewController.title = "Event"
            
            eventViewController.titleString = selectedEvent.title
            eventViewController.locationString = selectedEvent.location
            eventViewController.descriptionString = selectedEvent.description
            eventViewController.startTime = selectedEvent.start
            eventViewController.endTime = selectedEvent.end
            eventViewController.descriptionString = selectedEvent.information
        }
    }
    
}














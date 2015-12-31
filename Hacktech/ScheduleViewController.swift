//
//  ScheduleViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/27/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

let MSEventCellReuseIdentifier = "MSEventCellReuseIdentifier"
let MSDayColumnHeaderReuseIdentifier = "MSDayColumnHeaderReuseIdentifier"
let MSTimeRowHeaderReuseIdentifier = "MSTimeRowHeaderReuseIdentifier"

class ScheduleViewController: UICollectionViewController, MSCollectionViewDelegateCalendarLayout {
    
    var collectionViewCalendarLayout: MSCollectionViewCalendarLayout = MSCollectionViewCalendarLayout()
    
    var eventArr = [[MSEvent]]()
    
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
        
        let plistPath = NSBundle.mainBundle().pathForResource("EventSchedule", ofType: "plist")
        let contentArray = NSArray(contentsOfFile: plistPath!)!
        

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm zz"
        
        for day in 0..<contentArray.count {
            // new event array for a specific day
            var dayArr = [MSEvent]()
            
            // info from plist to fill dayArr
            let dayArrPlist = contentArray[day] as! NSArray
            
            for eventIndex in 0..<contentArray[day].count {
                
                    // new event
                    let event = MSEvent.create()
                    // info from plist to fill event
                    let eventDict = dayArrPlist[eventIndex] as! NSDictionary
                    event.start = dateFormatter.dateFromString(eventDict["start"] as! String)!
                    event.durationInHours = eventDict["durationInHours"] as! Double
                    event.title = eventDict["title"] as! String
                    event.location = eventDict["location"] as! String
                    event.information = eventDict["information"] as! String
                    dayArr.append(event)
            }
            self.eventArr.append(dayArr)
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
        return self.eventArr.count;
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
        
        return event.start.dateByAddingTimeInterval(60 * 60 * event.durationInHours - 0.005)
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
            eventViewController.durationInHours = selectedEvent.durationInHours
            eventViewController.descriptionString = selectedEvent.information
        }
    }
    
}














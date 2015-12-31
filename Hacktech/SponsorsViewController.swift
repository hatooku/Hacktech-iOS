//
//  SponsorsViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/23/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

// fillerRow is placed to prevent last row from being out of line
let partnerArray = [UIImage(named: "mlh"), UIImage(named: "hackerfund")]


let sponsorArray = [UIImage(named: "microsoft"),
    UIImage(named: "synaptics"),
    UIImage(named: "wolfram"),
    UIImage(named: "namecheap"),
    UIImage(named: "google"),
    UIImage(named: "hellosign"),
    UIImage(named: "soylent"),
    UIImage(named: "jetbrains"),
    UIImage(named: "drawattention"),
    UIImage(named: "hackerrank"),
    UIImage(named: "bitalino"),
    UIImage(named: "plux")]


let imgArray = [partnerArray, sponsorArray]

let headerNames = ["Partners", "Sponsors"]

let headerSize = CGSizeMake(600, 55)

let partnerCellSizeArr = [CGSizeMake(125.0, 125.0), CGSizeMake(140.0, 140.0)]

let sponsorCellSize = CGSizeMake(100.0, 100.0)

class SponsorsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return imgArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray[section].count
    }


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SponsorCell", forIndexPath: indexPath) as! SponsorCell
        
        let sponsorImg = imgArray[indexPath.section][indexPath.row]
        
        let resizedImg = sponsorImg?.resizedImageWithSize(cell.imageView.frame.size)
        
        cell.imageView.image = resizedImg
        
        cell.layer.shouldRasterize = true
        
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let section = indexPath.section
        
        if (section == 0) {
            return partnerCellSizeArr[indexPath.row]
        }
        
        return sponsorCellSize
        
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if (section == 0) {
            let viewWidth = collectionView.frame.width
            
            let leftInset = max((viewWidth / 2.0 - partnerCellSizeArr[0].width) / 2.0, CGFloat(0.0))
            
            let rightInset = max((viewWidth / 2.0 - partnerCellSizeArr[1].width) / 2.0, CGFloat(0.0))
            
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }
        
        return UIEdgeInsetsZero
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if (section == 0) {
            let frameWidth = collectionView.frame.width
            
            let cellsWidth = partnerCellSizeArr[0].width + partnerCellSizeArr[1].width
            
            if (frameWidth <= cellsWidth) {
                return CGFloat(0.0)
            }
            
            return (collectionView.frame.width - cellsWidth) / 2.0
        }
        
        return CGFloat(0.0)
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView =
        collectionView.dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: "Header",
            forIndexPath: indexPath)
            as! SponsorHeader
        headerView.label.text = headerNames[indexPath.section]
        return headerView
    }
}


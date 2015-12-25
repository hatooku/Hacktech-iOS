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

/*
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
    UIImage(named: "plux"),
    UIImage(named: "fillerRow")] */

let row1 = [UIImage(named: "microsoft"), UIImage(named: "synaptics")]
let row2 = [UIImage(named: "wolfram"), UIImage(named: "namecheap")]
let row3 = [UIImage(named: "google"), UIImage(named: "hellosign")]
let row4 = [UIImage(named: "soylent"), UIImage(named: "jetbrains")]
let row5 = [UIImage(named: "drawattention"), UIImage(named: "hackerrank")]
let row6 = [UIImage(named: "bitalino"), UIImage(named: "plux")]


let imgArray = [partnerArray, row1, row2, row3, row4, row5, row6]

let headerNames = ["Partners", "Sponsors"]

let headerSize = CGSizeMake(600, 55)

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
        
        cell.imageView?.image = imgArray[indexPath.section][indexPath.row]
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let img = imgArray[indexPath.section][indexPath.row]!
        return CGSizeMake(img.size.width, img.size.height)
    }

    
    // Total width of cells in each section (row)
    func sectionWidth(section: Int) -> CGFloat {
        var width = CGFloat(0.0)
        for img in imgArray[section] {
            width = width + img!.size.width
        }
        
        return width
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        

        let viewWidth = collectionView.frame.width
        
        let firstImgWidth = imgArray[section][0]!.size.width
        
        let secondImgWidth: CGFloat
        
        if (imgArray[section].count == 1) {
            secondImgWidth = CGFloat(0.0)
        }
        else {
            secondImgWidth = imgArray[section][1]!.size.width
        }
        
        let leftInset = max((viewWidth / 2.0 - firstImgWidth) / 2.0, CGFloat(0.0))
        
        let rightInset = max((viewWidth / 2.0 - secondImgWidth) / 2.0, CGFloat(0.0))
        
        return UIEdgeInsetsMake(11, leftInset, 11, rightInset)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {

        let frameWidth = collectionView.frame.width
        
        let cellsWidth = sectionWidth(section)
        
        if (frameWidth <= cellsWidth) {
            return CGFloat(0.0)
        }
        
        return (collectionView.frame.width - sectionWidth(section)) / 2.0
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section > 1) {
            return CGSizeZero
        }
        
        return headerSize
    }

    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView =
            collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "Header",
                forIndexPath: indexPath)
                as! SponsorHeader
            headerView.label.text = headerNames[indexPath.section]

            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }

}


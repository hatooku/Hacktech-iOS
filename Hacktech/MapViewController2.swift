//
//  SecondViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/14/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class MapViewController2: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!

    let maps = [UIImage(named: "map1.png"), UIImage(named: "map2.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        pageControl.numberOfPages = maps.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maps.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("MapCell", forIndexPath: indexPath) as! MapCell
        
        cell.imageView.image = maps[indexPath.row]?.resizedImageWithSize(collectionView.bounds.size)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
/*
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = Int(round(self.collectionView!.contentOffset.x / self.collectionView!.frame.width))
        
        pageControl.currentPage = index
    }
    
    @IBAction func pageControlValueChanged() {
        
        self.collectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem: pageControl.currentPage, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    }
*/

}
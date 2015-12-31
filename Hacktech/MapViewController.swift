//
//  MapViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/25/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = []
    
    // ImageViews inside ScrollViews to allow for zooming of images
    var pageViews: [UIScrollView?] = []
    
    var currentPageView: UIView!
    
    let viewForZoomTag = 1
    let pageViewTag = 2
    
    var mainScrollViewContentSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageImages = [UIImage(named: "map1.png")!, UIImage(named: "map2.png")!]
        
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let pagesScrollViewSize = mainScrollView.frame.size
        mainScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        mainScrollViewContentSize = mainScrollView.contentSize
        
        loadVisiblePages()
    }

    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * mainScrollView.frame.size.width
        mainScrollView.setContentOffset(CGPointMake(x, 0), animated: true)
        loadVisiblePages()
        currentPageView = pageViews[pageControl.currentPage]
    }

    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if let pageView = pageViews[page] {
            pageView.zoomScale = 1.0
            // Do nothing
        } else {
            var frame = mainScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newScrollView = UIScrollView()
            newScrollView.frame = frame
            newScrollView.contentSize = frame.size
            
            newScrollView.tag = pageViewTag
            
            newScrollView.showsHorizontalScrollIndicator = false
            newScrollView.showsVerticalScrollIndicator = false
            
            newScrollView.maximumZoomScale = 3.0
            newScrollView.minimumZoomScale = 1.0
            
            newScrollView.zoomScale = 1.0
            newScrollView.delegate = self
            
            newScrollView.enableDoubleTap()
            
            let newImgView = UIImageView(image: pageImages[page])
            newImgView.contentMode = .ScaleAspectFit
            newImgView.frame.size = frame.size
            newImgView.tag = viewForZoomTag
            
            newScrollView.addSubview(newImgView)
            mainScrollView.addSubview(newScrollView)
            
            pageViews[page] = newScrollView
        }
        
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        let pageWidth = mainScrollView.frame.size.width
        let page = Int(floor((mainScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        for var index = lastPage + 1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(viewForZoomTag)
    }

    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = targetContentOffset.memory.x
        let zoomRatio = scrollView.contentSize.height / mainScrollViewContentSize.height
        
        if scrollView.tag == 0 {
            // mainScrollView
            
            let mainScrollViewWidthPerPage = mainScrollViewContentSize.width / CGFloat(pageControl.numberOfPages)
            
            
            let currentPage = targetOffset / (mainScrollViewWidthPerPage * zoomRatio)
            
            if pageControl.currentPage != Int(currentPage)
            {
                pageControl.currentPage = Int(currentPage)
                
                loadVisiblePages()
            }
        }
    }
}

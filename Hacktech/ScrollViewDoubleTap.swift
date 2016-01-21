//
//  ScrollViewDoubleTap.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/27/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func enableDoubleTapZoom() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (self.zoomScale > self.minimumZoomScale) {
            self.setZoomScale(self.minimumZoomScale, animated: true)
        } else {
            self.setZoomScale(self.maximumZoomScale, animated: true)
        }
    }
}


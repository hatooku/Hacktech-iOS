//
//  SecondViewController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/14/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var path = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        path = NSBundle.mainBundle().pathForResource("map", ofType: "pdf")!
        
        let url = NSURL.fileURLWithPath(path)
        
        self.webView.loadRequest(NSURLRequest(URL: url))
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


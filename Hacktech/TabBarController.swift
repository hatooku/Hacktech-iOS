//
//  TabBarController.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/21/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab bar background is transparent, shadow (line on top) is orange
        self.tabBar.backgroundImage = UIImage(named: "transparent.png")
        self.tabBar.shadowImage = UIImage(named: "orange.png")
    }
}
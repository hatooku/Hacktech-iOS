//
//  SponsorCell.swift
//  Hacktech
//
//  Created by Joon Hee Lee on 12/23/15.
//  Copyright © 2015 hacktech. All rights reserved.
//

import UIKit

class SponsorCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

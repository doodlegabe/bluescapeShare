//
//  ShareImageCollectionCell.swift
//  bluescapeShareExtension
//
//  Created by Gabriel Walsh on 9/20/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit

class ShareImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(image: UIImage) {
        self.imageView.image = image
    }
}

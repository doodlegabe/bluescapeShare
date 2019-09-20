//
//  ImageCollectionCell.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/20/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    var item: CellModel? {
        didSet{
            self.config(item)
        }
    }
    
    func config(_ item: CellModel?){
        if let model = item {
            self.imgView.image = model.image
        }
    }
    
}

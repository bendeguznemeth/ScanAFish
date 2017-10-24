//
//  PhotoCollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Németh Bendegúz on 2017. 10. 23..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
    }
    
}


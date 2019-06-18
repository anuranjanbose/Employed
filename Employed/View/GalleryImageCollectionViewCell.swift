//
//  GalleryImageCollectionViewCell.swift
//  Employed
//
//  Created by Anuranjan Bose on 12/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class GalleryImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fetchImage(image: UIImage, imageTitle: String) {
        self.galleryImageView.image = image
        self.imageTitleLabel.text = imageTitle
        self.activityIndicator.isHidden = true
    }
}

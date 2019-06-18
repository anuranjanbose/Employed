//
//  CustomSegment.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class CustomSegment: UIView {


    @IBOutlet weak var addImageToGalleryButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var addLocationToMapButton: UIButton!
    
    @IBOutlet weak var galleryStackView: UIStackView!
    
    @IBOutlet weak var mapStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerNib()
    }
    
    private func registerNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomSegment", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            self.addSubview(view)
        }
        
    }
}

//
//  Toast.swift
//  Employed
//
//  Created by Anuranjan Bose on 12/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation
import UIKit

protocol Toast {
    func toast(message : String)
}

extension UILabel : Toast {
    
    func toast(message: String)  {
        self.isHidden = false
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        self.textColor = UIColor.black
        self.textAlignment = .center
      //  self.font = UIFont(name: "Chalkduster", size: 20.0)
        self.text = message
        self.alpha = 1.0
        self.layer.cornerRadius = 10
        self.clipsToBounds  =  true
        UIView.animate(withDuration: 7.0, delay: 0.0, options: .transitionCurlUp, animations: {
            self.alpha = 0.0
        }, completion: {(isCompleted) in
            // self.isHidden = true
        })
    }
}

//
//  ImageLoading.swift
//  Employed
//
//  Created by Anuranjan Bose on 12/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public static func loadImage(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

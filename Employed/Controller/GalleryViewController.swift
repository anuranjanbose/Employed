//
//  GalleryViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var imageArray = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
       
        fetchImageFromJSON()
        
        // nib register
        let nib = UINib.init(nibName: "GalleryImageCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "GalleryImageCollectionViewCell")
    }

    
    func fetchImageFromJSON() {
        let jsonURL = URL(string: "https://picsum.photos/list")
        let session = URLSession(configuration: .default)
        let sessionTask = session.dataTask(with: jsonURL!) { (data, response, error) in
            do {
                if error == nil {
                    self.imageArray = try JSONDecoder().decode([Image].self, from: data!)
                    DispatchQueue.main.async {
                        self.galleryCollectionView.reloadData()
                    }
                }
            } catch {
                print("Error While loading data")
            }
        }
        sessionTask.resume()
        }
    }

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let widthOfImage = (collectionView.bounds.width/2.0) - 15
        let heightOfImage = widthOfImage * (3/4)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryImageCollectionViewCell", for: indexPath) as! GalleryImageCollectionViewCell
        // let urls = "https://picsum.photos/id/\(Int(imageArray[indexPath.row].id))/\(Int(widthOfImage))/\(Int(heightOfImage))"
        let url = "https://picsum.photos/\(Int(widthOfImage))/\(Int(heightOfImage))"
        guard let imageURL = URL(string: url) else { return cell }
        UIImage.loadImage(url: imageURL) { image in
            if let image = image {
                cell.fetchImage(image: image)
            }
        }
        return cell
    }
}




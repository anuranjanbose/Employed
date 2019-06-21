//
//  GalleryViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    
    
    var counter = 0
    var countOfItems : Int = 10
    var startIndex = 1

    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    struct GoogleApiStruct: Decodable {
        let items: [SubItems]
    }
    

    struct SubItems: Decodable{
        let title: String
        let image: SubImageInfo
    }
    
    struct SubImageInfo: Decodable {
        let height: Int
        let width: Int
        let thumbnailLink: String
    }
    
    
    var storingArray:  [GoogleApiStruct]?
    
    var imageArray = [String]()
    var titleArray = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.galleryCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.borderColor = UIColor.black.cgColor
        loadMoreButton.backgroundColor = .lightGray
        loadMoreButton.setTitleColor(.black, for: .normal)
        self.storingArray = [GoogleApiStruct]()
        
        fetchImageFromJSON()
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        // nib register
        let nib = UINib.init(nibName: "GalleryImageCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "GalleryImageCollectionViewCell")
        
    }
    
    func fetchImageFromJSON() {
        
        let jsonStringUrl = "https://www.googleapis.com/customsearch/v1?q=mango&cx=014779335774980121077%3Aj4u2pcebgfi&searchType=image&key=AIzaSyDLVtX2qzmmmQAbfeYAVB011zADQNZKD74&start=\(self.startIndex)&num=\(self.countOfItems)"
        
        guard let url = URL(string: jsonStringUrl) else { return }
        URLSession.shared.dataTask(with: url)  { ( data,response,err ) in
            
            guard let data = data else { return }
            
            do {
                let arrayData = try JSONDecoder().decode(GoogleApiStruct.self, from: data)
                
//                self.storingArrayTemp = [GoogleApiStruct]()
//
//                self.storingArrayTemp = [arrayData]
    
            //    self.storingArray?.append(arrayData)
                DispatchQueue.main.async {
                    var arrayImageURL = [String]()
                    var arrayTitle = [String]()
                    
                    for items in 0...9 {
                        
                        arrayImageURL.append(arrayData.items[items].image.thumbnailLink)
                        arrayTitle.append(arrayData.items[items].title)
                        
                    }
                    
                    self.fillImage(imageURL: arrayImageURL, imageTitle: arrayTitle)
                    
                    DispatchQueue.main.async {
                        self.galleryCollectionView.reloadData()
                    }
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
        
    }
    
    
    
    func fillImage(imageURL: [String], imageTitle: [String]) {
        for item in imageURL {
            self.imageArray.append(item)
        }
        
        for item in imageTitle {
            self.titleArray.append(item)
        }
    }
    
    @IBAction func loadMoreButton(_ sender: UIButton) {
        
        
        self.startIndex = self.startIndex + self.countOfItems
        self.counter = self.counter + 1
        self.fetchImageFromJSON()
    }
    
}


extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let widthOfImage = (collectionView.bounds.width/2.0) - 15
        let heightOfImage = widthOfImage * (3/4)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryImageCollectionViewCell", for: indexPath) as! GalleryImageCollectionViewCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.contentView.layer.cornerRadius = 3.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        do {
            
           
                let url = self.imageArray[indexPath.row]
                let title = self.titleArray[indexPath.row]
             //   let url = storingArray?[self.counter].items[indexPath.row].image.thumbnailLink
                guard let imageURL = URL(string: url) else { return cell }
                UIImage.loadImage(url: imageURL) { image in
                    
                    if let image = image {
                        cell.fetchImage(image: image, imageTitle: title)
                    }
                }
            
        } catch {
            print("error index out")
        }
        
        return cell
        
    }
    
}


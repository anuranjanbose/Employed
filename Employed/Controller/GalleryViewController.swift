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
    
    
    struct GoogleApiStruct: Decodable {
        
        let kind: String
        let url: urlDefination?
        let queries: SubQueries
        let context: SubContext
        let searchInformation: SubSearchInformation
        let items: [SubItems]
    }
    
    struct urlDefination: Decodable{
        
        let type: String
        let tempelate: String?
    }
    
    struct SubQueries: Decodable{
        
        let request: [RequestSub]
        let nextPage: [SubNextPage]
    }
    
    struct RequestSub: Decodable {
        
        let title: String
        let totalResults: String
        let searchTerms: String
        let count: Int
        let startIndex: Int
        let inputEncoding: String
        
        let outputEncoding: String
        
        let safe: String
        
        let cx: String
        
        let searchType: String
        
    }
    
    
    
    struct SubNextPage: Decodable {
        
        let title: String
        
        let totalResults: String
        
        let searchTerms: String
        
        let count: Int
        
        let startIndex: Int
        
        let inputEncoding: String
        
        let outputEncoding: String
        
        let safe: String
        
        let cx: String
        
        let searchType: String
        
    }
    
    
    
    struct SubContext: Decodable {
        
        let title: String
        
    }
    
    
    
    struct SubSearchInformation: Decodable{
        
        let searchTime: Float
        
        let formattedSearchTime: String
        
        let totalResults: String
        
        let formattedTotalResults:String
        
        
        
    }
    
    
    
    struct SubItems: Decodable{
        
        let kind: String
        
        let title: String
        
        let htmlTitle: String
        
        let link: String
        
        let displayLink: String
        
        let snippet: String
        
        let htmlSnippet: String
        
        let mime: String
        
        let image: SubImageInfo
        
        
        
    }
    
    
    
    struct SubImageInfo: Decodable {
        
        let contextLink: String
        let height: Int
        let width: Int
        let byteSize:Int
        let thumbnailLink: String
        let thumbnailHeight: Int
        let thumbnailWidth: Int
    }
    
    
    
    var storingArray: [GoogleApiStruct]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImageFromJSON()
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        
        
        // nib register
        
        let nib = UINib.init(nibName: "GalleryImageCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "GalleryImageCollectionViewCell")
        
    }
    
    
    
    
    
    
    
    func fetchImageFromJSON() {
        
        let jsonStringUrl =   "https://www.googleapis.com/customsearch/v1?q=mango&cx=014779335774980121077%3Aj4u2pcebgfi&searchType=image&key=AIzaSyDFQJjdsS7BbaEUQYfbwOT93j00GO9kKQw&start=1&num=2"
        
        
        
        guard let url = URL(string: jsonStringUrl) else { return }
        URLSession.shared.dataTask(with: url)  { ( data,response,err ) in
            
            guard let data = data else { return }
            
            
            
            do{
                
                
                
                
                
                let arrayData = try JSONDecoder().decode(GoogleApiStruct.self, from: data)
                
                self.storingArray = [GoogleApiStruct]()
                
                self.storingArray = [arrayData]
                
                print(self.storingArray?[0].items[1].image.thumbnailLink)
                
                
                
                
                
                DispatchQueue.main.async {
                    
                    
                    
                    self.galleryCollectionView.reloadData()
                    
                }
                
                
                
                
                
                
                
            } catch let jsonErr{
                
                print(jsonErr)
                
            }
            
            
            
            
            
            }.resume()
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    //    func dataFetch(){
    
    //        for i in 1...3 {
    
    //            if let data = [storingArray] {
    
    //                flag = 1
    
    //
    
    //                break
    
    //            }
    
    //        }
    
    //
    
    //    }
    
    
    
}







extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (storingArray?[0].items.count) ?? 0
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let widthOfImage = (collectionView.bounds.width/2.0) - 15
        
        let heightOfImage = widthOfImage * (3/4)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryImageCollectionViewCell", for: indexPath) as! GalleryImageCollectionViewCell
        
        // let urls = "https://picsum.photos/id/\(Int(imageArray[indexPath.row].id))/\(Int(widthOfImage))/\(Int(heightOfImage))"
        
        do{
            
            if (storingArray?[0].items.count)! > 0 {
                
                let url = storingArray?[0].items[0].image.thumbnailLink
                
                guard let imageURL = URL(string: url!) else { return cell }
                
                UIImage.loadImage(url: imageURL) { image in
                    
                    if let image = image {
                        
                        cell.fetchImage(image: image)
                        
                    }
                    
                }
                
            }
            
        }
            
        catch
            
        {
            
            print("error index out ")
            
        }
        
        
        
        
        
        
        
        return cell
        
    }
    
    
    
}


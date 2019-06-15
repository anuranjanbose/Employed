//
//  DetailViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import MapKit
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var employeeSalaryLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeAgeLabel: UILabel!
    @IBOutlet weak var employeeMapView: MKMapView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    @IBOutlet weak var customSegment: CustomSegment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        let nib = UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        performActions()
        fillDetailsOfEmployee()
        //performActions()
    }
    private func performActions() {
        customSegment.galleryButton.addTarget(self, action: #selector(self.onClickGalleryButton), for: .touchUpInside)
        
        customSegment.addImageToGalleryButton.addTarget(self, action: #selector(self.onClickAddPhotoButton), for: .touchUpInside)
        
        customSegment.mapButton.addTarget(self, action: #selector(self.onClickMapButton), for: .touchUpInside)
        
        customSegment.addLocationToMapButton.addTarget(self, action: #selector(self.onClickAddMapButton), for: .touchUpInside)
    }
    
    @objc func onClickAddPhotoButton() {
        
        customSegment.galleryButton.backgroundColor = .lightGray
        customSegment.addImageToGalleryButton.backgroundColor = .lightGray
        customSegment.mapButton.backgroundColor = .clear
        customSegment.addLocationToMapButton.backgroundColor = .clear
    }
    
    @objc func onClickGalleryButton() {
        customSegment.galleryButton.layer.borderWidth = 1
        customSegment.galleryButton.layer.borderColor = UIColor.black.cgColor
        employeeMapView.isHidden = true
        galleryCollectionView.isHidden = false
        customSegment.galleryButton.backgroundColor = .lightGray
        customSegment.addImageToGalleryButton.backgroundColor = .lightGray
        customSegment.mapButton.backgroundColor = .clear
        customSegment.addLocationToMapButton.backgroundColor = .clear
    }
    
    @objc func onClickMapButton() {
        galleryCollectionView.isHidden = true
        employeeMapView.isHidden = false
        customSegment.mapButton.backgroundColor = .lightGray
        customSegment.addLocationToMapButton.backgroundColor = .lightGray
        customSegment.galleryButton.backgroundColor = .clear
        customSegment.addImageToGalleryButton.backgroundColor = .clear
    }
    
    @objc func onClickAddMapButton() {
        customSegment.mapButton.backgroundColor = .lightGray
        customSegment.addLocationToMapButton.backgroundColor = .lightGray
        customSegment.galleryButton.backgroundColor = .clear
        customSegment.addImageToGalleryButton.backgroundColor = .clear
    }
    
}


extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (galleryCollectionView.frame.width-30)/3
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func fillDetailsOfEmployee() {
        employeeNameLabel.text = employeeName
        employeeSalaryLabel.text = employeeSalary
        employeeAgeLabel.text = employeeAge
    }
}

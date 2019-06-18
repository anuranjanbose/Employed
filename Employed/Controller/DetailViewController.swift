//
//  DetailViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import MapKit
import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, SaveAnnotation {
    
    @IBOutlet weak var employeeSalaryLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeAgeLabel: UILabel!
    @IBOutlet weak var employeeMapView: MKMapView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var customSegment: CustomSegment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationItem.title = "Employee Details"
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        employeeMapView.addGestureRecognizer(longPressRecogniser)
        
        employeeMapView.mapType = MKMapType.standard
        employeeMapView.showsUserLocation = true
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.stopUpdatingLocation()
        }
        
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        let nib = UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        performActions()
        fillDetailsOfEmployee()
        //performActions()
    }
    
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            let location = gestureReconizer.location(in: employeeMapView)
            let coordinate = employeeMapView.convert(location,toCoordinateFrom: employeeMapView)
            
            // Add annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "latitude:" + String(format: "%.02f",annotation.coordinate.latitude) + "& longitude:" + String(format: "%.02f",annotation.coordinate.longitude)
            employeeMapView.addAnnotation(annotation)
            addData(name: self.employeeNameLabel.text! , longitude: annotation.coordinate.longitude, latitude: annotation.coordinate.latitude)
            
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            urls[urls.count-1] as NSURL
            print(urls)
        }
    }
    
    
    private func performActions() {
        customSegment.galleryButton.addTarget(self, action: #selector(self.onClickGalleryButton), for: .touchUpInside)
        
        customSegment.addImageToGalleryButton.addTarget(self, action: #selector(self.onClickAddPhotoButton), for: .touchUpInside)
        
        customSegment.mapButton.addTarget(self, action: #selector(self.onClickMapButton), for: .touchUpInside)
        
        customSegment.addLocationToMapButton.addTarget(self, action: #selector(self.onClickAddMapButton), for: .touchUpInside)
    }
    
    @objc func onClickAddPhotoButton() {
        
        //customSegment.galleryButton.backgroundColor = .lightGray
        //customSegment.addImageToGalleryButton.backgroundColor = .lightGray
        customSegment.mapButton.backgroundColor = .clear
        customSegment.mapButton.setTitleColor(.black, for: .normal)
        customSegment.addLocationToMapButton.backgroundColor = .clear
    }
    
    @objc func onClickGalleryButton() {
       // customSegment.galleryButton.layer.borderWidth = 1
       // customSegment.galleryButton.layer.borderColor = UIColor.black.cgColor
        employeeMapView.isHidden = true
        galleryCollectionView.isHidden = false
        //customSegment.galleryButton.backgroundColor = .lightGray
        //customSegment.addImageToGalleryButton.backgroundColor = .lightGray
        customSegment.mapButton.backgroundColor = .clear
        customSegment.mapButton.setTitleColor(.black, for: .normal)
        
        customSegment.galleryButton.backgroundColor = .black
        customSegment.galleryButton.setTitleColor(.white, for: .normal)
    }
    
    @objc func onClickMapButton() {
        galleryCollectionView.isHidden = true
        employeeMapView.isHidden = false
        
       // customSegment.mapButton.backgroundColor = .lightGray
       // customSegment.addLocationToMapButton.backgroundColor = .lightGray
        
        customSegment.mapButton.backgroundColor = .black
        customSegment.mapButton.setTitleColor(.white, for: .normal)
        
        customSegment.galleryButton.setTitleColor(.black, for: .normal)
        customSegment.galleryButton.backgroundColor = .clear
        //customSegment.addImageToGalleryButton.backgroundColor = .clear
    }
    
    @objc func onClickAddMapButton() {
      //  customSegment.mapButton.backgroundColor = .lightGray
      //  customSegment.addLocationToMapButton.backgroundColor = .lightGray
        customSegment.galleryButton.backgroundColor = .clear
        customSegment.galleryButton.setTitleColor(.black, for: .normal)
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

//
//  DetailViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 11/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import MapKit
import UIKit
import CoreData

class DetailViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, SaveDataToCoreData, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var addAnnotationStatusToastLabel: UILabel!
    @IBOutlet weak var employeeSalaryLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeAgeLabel: UILabel!
    @IBOutlet weak var employeeMapView: MKMapView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    
    var addLocationOnMap = false
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var customSegment: CustomSegment!
    
    var galleryImageURL = [String]()
    var galleryImageTitle = [String]()
    
    
    fileprivate lazy var fetchedResultController1: NSFetchedResultsController<EmployeeImage> =
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = EmployeeImage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "imageURL", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        try! fetchResultController.performFetch()
        return fetchResultController as! NSFetchedResultsController<EmployeeImage>
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.galleryImageURL.removeAll()
        
        for item in fetchedResultController1.fetchedObjects! {
            self.galleryImageURL.append(item.imageURL!)
         //   self.galleryImageTitle.append(item.employeeName!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
//        customSegment.layer.masksToBounds = false
//        customSegment.layer.shadowColor = UIColor.black.cgColor
//        customSegment.layer.shadowOpacity = 0.5
//        customSegment.layer.shadowOffset = CGSize(width: -1, height: 1)
//        customSegment.layer.shadowRadius = 1
        
        
        
        customSegment.galleryButton.backgroundColor = .lightGray
        customSegment.mapButton.backgroundColor = .lightGray
        customSegment.mapButton.setTitleColor(.black, for: .normal)
        customSegment.galleryButton.setTitleColor(.white, for: .normal)
        
        customSegment.addImageToGalleryButton.layer.borderWidth = 1
        customSegment.addImageToGalleryButton.layer.borderColor = UIColor.black.cgColor
        
        customSegment.addLocationToMapButton.layer.borderWidth = 1
        customSegment.addLocationToMapButton.layer.borderColor = UIColor.black.cgColor
        
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
        
        
       
        
        let nib = UINib.init(nibName: "CustomCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        performActions()
        fillDetailsOfEmployee()
        
        for item in fetchedResultController1.fetchedObjects! {
            
                self.galleryImageURL.append(item.imageURL!)
             //   self.galarytitle.append(item.employeeName ?? "")
            
        }
        //performActions()
    }
    
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        
        if addLocationOnMap {
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
        
        if !employeeMapView.isHidden {
            employeeMapView.isHidden = true
            galleryCollectionView.isHidden = false
        }
        
        customSegment.mapButton.backgroundColor = .lightGray
        customSegment.mapButton.setTitleColor(.white, for: .normal)
        //customSegment.addLocationToMapButton.backgroundColor = .clear
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionStyleSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionStyleSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action : UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionStyleSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil ))
        self.present(actionStyleSheet, animated: true, completion: nil)
    }
    
    @objc func onClickGalleryButton() {
       // customSegment.galleryButton.layer.borderWidth = 1
       // customSegment.galleryButton.layer.borderColor = UIColor.black.cgColor
        
        
        employeeMapView.isHidden = true
        galleryCollectionView.isHidden = false
        //customSegment.galleryButton.backgroundColor = .lightGray
        //customSegment.addImageToGalleryButton.backgroundColor = .lightGray
        customSegment.mapButton.backgroundColor = .lightGray
        customSegment.mapButton.setTitleColor(.white, for: .normal)
        
        customSegment.galleryButton.backgroundColor = .lightGray
        customSegment.galleryButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func onClickMapButton() {
        galleryCollectionView.isHidden = true
        employeeMapView.isHidden = false
        
       // customSegment.mapButton.backgroundColor = .lightGray
       // customSegment.addLocationToMapButton.backgroundColor = .lightGray
        
        customSegment.mapButton.backgroundColor = .lightGray
        customSegment.mapButton.setTitleColor(.black, for: .normal)
        
        customSegment.galleryButton.setTitleColor(.white, for: .normal)
        customSegment.galleryButton.backgroundColor = .lightGray
        //customSegment.addImageToGalleryButton.backgroundColor = .clear
    }
    
    @objc func onClickAddMapButton() {
      //  customSegment.mapButton.backgroundColor = .lightGray
      //  customSegment.addLocationToMapButton.backgroundColor = .lightGray
        
        if !galleryCollectionView.isHidden {
            galleryCollectionView.isHidden = true
            employeeMapView.isHidden = false
        }
        
        customSegment.galleryButton.backgroundColor = .lightGray
        customSegment.galleryButton.setTitleColor(.white, for: .normal)
        
        if addLocationOnMap {
            addLocationOnMap = false
           // customSegment.addLocationToMapButton.isSelected = false
//            customSegment.addLocationToMapButton.tintColor = .black
//            customSegment.addLocationToMapButton.backgroundColor = .white
            print("Add location on map disabled")
            addAnnotationStatusToastLabel.toast(message: "Annotation addition disabled")
        } else {
            addLocationOnMap = true
            
//            customSegment.addLocationToMapButton.tintColor = .white
//            customSegment.addLocationToMapButton.backgroundColor = .black
          //  customSegment.addLocationToMapButton.isSelected = true
            addAnnotationStatusToastLabel.toast(message: "Annotation addition enabled")
            print("Add location on map enabled")
        }
    }
    
}


extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
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
        do {
            let url = self.galleryImageURL[indexPath.row]
           // let title = self.galleryImageTitle[indexPath.row]
            guard let imageURL = URL(string: url) else { return cell }
            UIImage.loadImage(url: imageURL) { image in
                if let image = image {
                    cell.galleryImageView.image = image
                  //  cell.galleryImageTitle.text = title
                }
            }
        }
        
        
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



extension DetailViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.employeeMapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to access your Current Location")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("update in db")
        //self.galleryCollectionView.reloadData()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("update in db done")
        self.galleryCollectionView.reloadData()
    }
    
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageurl = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let myString = imageurl.absoluteString
        self.galleryImageURL.append(myString!)
        addEmployeeImageToGallery(imageURL: myString! , employeeName: self.employeeNameLabel?.text ?? "" )
        self.galleryCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}



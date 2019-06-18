//
//  MapViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 10/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit
import MapKit
import CoreData



class MapViewController: UIViewController, NSFetchedResultsControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Annotation> =
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = Annotation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate
        try! fetchResultController.performFetch()
        return fetchResultController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapView.layer.borderWidth = 1.0
        tapView.layer.masksToBounds = false
        tapView.layer.borderColor = UIColor.white.cgColor
        tapView.layer.cornerRadius = tapView.frame.size.width / 2
        tapView.clipsToBounds = true
        
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied
        {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.stopUpdatingLocation()
            
        }
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        
        
        
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tap.delegate = self
        tapView.addGestureRecognizer(tap)
        
        
    }
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        for item in fetchedResultController.fetchedObjects!
        {
            let annotations = MKPointAnnotation()
            annotations.title = item.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            mapView.addAnnotation(annotations)
        }
        print(fetchedResultController.fetchedObjects!.count)
    }
    
    
}




extension MapViewController {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to access your Current Location")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Location updation in process")
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Location updation is done")
    }
    
}





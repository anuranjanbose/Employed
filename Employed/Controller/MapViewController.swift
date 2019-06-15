//
//  MapViewController.swift
//  Employed
//
//  Created by Anuranjan Bose on 10/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import UIKit
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let firstCoordinate = CLLocationCoordinate2D(latitude: 28.6343, longitude: 77.4455)
        let firstAnnotation = CustomAnnotation(coordinate: firstCoordinate, title: "ABES College", subtitle: "College")
        
//        let secondCoordinate = CLLocationCoordinate2D(latitude: 28.5339, longitude: 77.3482)
//        let secondAnnotation = CustomAnnotation(coordinate: secondCoordinate, title: "To The New", subtitle: "Work Place")
        let thirdCoordinate = CLLocationCoordinate2D(latitude: 28.6758, longitude: 77.5022)
        let thirdAnnotation = CustomAnnotation(coordinate: thirdCoordinate, title: "AKGEC", subtitle: "College")
//        let fourthCoordinate = CLLocationCoordinate2D(latitude: 28.6170, longitude: 77.3009)
//        let fourthAnnotation = CustomAnnotation(coordinate: fourthCoordinate, title: "Mayur Vihar Phase-2", subtitle: "Home")
//        let fifthCoordinate = CLLocationCoordinate2D(latitude: 28.6129, longitude: 77.2295)
//        let fifthAnnotation = CustomAnnotation(coordinate: fifthCoordinate, title: "India Gate", subtitle: "New Delhi")
        
        mapView.addAnnotation(firstAnnotation)
//        mapView.addAnnotation(secondAnnotation)
        mapView.addAnnotation(thirdAnnotation)
//        mapView.addAnnotation(fourthAnnotation)
//        mapView.addAnnotation(fifthAnnotation)
        
        
        let firstCircle = MKCircle(center: firstCoordinate, radius: 1000 as CLLocationDistance)
        self.mapView.addOverlay(firstCircle)
        
        let secondCircle = MKCircle(center: thirdCoordinate, radius: 1000 as CLLocationDistance)
        self.mapView.addOverlay(secondCircle)
        
        mapView.setRegion(firstAnnotation.region, animated: true)
        
//        let sourcePlaceMark = MKPlacemark(coordinate: firstCoordinate)
//        let destinationPlaceMark = MKPlacemark(coordinate: thirdCoordinate)
//        let directionRequest = MKDirections.Request()
//        
//        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
//        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
//        directionRequest.transportType = .automobile
//        let direction = MKDirections(request: directionRequest)
//        direction.calculate{(response,error ) in
//            guard let directionResponse = response else{
//                if let error = error {
//                    print("we have error in getting direction \(error.localizedDescription)")
//                }
//                return
//            }
//            let route = directionResponse.routes[0]
//            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//            let rect =  route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
//            self.mapView.delegate = self
//            // Do any additional setup after loading the view.
//        }
    }
    
    
    
}


extension MapViewController: MKMapViewDelegate {
    //Actions on annotation function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            customAnnotationView.animatesWhenAdded = true
            customAnnotationView.titleVisibility = .adaptive
            customAnnotationView.subtitleVisibility = .adaptive
            customAnnotationView.canShowCallout = true
            customAnnotationView.rightCalloutAccessoryView = UIButton(type: .infoDark)
            //customAnnotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
            return customAnnotationView
        }
        return nil
    }
    
    
    //Function for customising overlays
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        if overlay is MKCircle {
//            let circle = MKCircleRenderer(overlay: overlay)
//            circle.strokeColor = UIColor.blue
//            circle.fillColor = UIColor(red: 0, green: 100, blue: 100, alpha: 0.1)
//            circle.lineWidth =  2.0
//            return circle
//        } else if overlay is MKPolyline {
//            let renderer = MKPolylineRenderer.init(overlay: overlay)
//            renderer.strokeColor = UIColor.blue
//            renderer.lineWidth = 4.0
//            return renderer
//        } else {
//            return MKPolylineRenderer()
//        }
//    }
    
    //On clicking the annotation, it opens a new view controller
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
//            if let goToDescription = view.annotation?.title! {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyBoard.instantiateViewController(withIdentifier: "RandomViewController")
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
        }
    }
}

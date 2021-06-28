//
//  MapViewController.swift
//
//  Created by Jason on 3/23/15. and modified by Eduardo on 16/06/21
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

/**
* This view controller demonstrates the objects involved in displaying pins on a map.
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method
* invocation when a pin annotation is tapped. It accomplishes this using two delegate
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

class MapViewController: SharedViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getStudentLocations()
    }
    
    // MARK: logout
    @IBAction func logoutAction(_ sender: Any) {
        logout()
    }
    
    // MARK: get student locations
    
    func getStudentLocations(){
        toggleLoadingIndicator(true)
        UdacityAPI.shared().getLocations(completion: handleAddStudentLocation(locations:error:))
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
       
        getStudentLocations()
    }
    
    func handleAddStudentLocation(locations: [StudentInformation]?, error: Error?){
        if error != nil {
            self.showAlertModal("Map problem", error?.localizedDescription ?? "Not able to display student locations")
            return
        }
        var annotations = [MKPointAnnotation]()

        for dictionary in locations ?? [] {

            let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
            let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
        toggleLoadingIndicator(false)
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(control)
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openURL(toOpen)
            }
        }
    }
}

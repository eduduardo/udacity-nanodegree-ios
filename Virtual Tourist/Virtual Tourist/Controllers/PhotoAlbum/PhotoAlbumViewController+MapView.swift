//
//  PhotoAlbumViewController+MapView.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 27/06/21.
//

import MapKit

extension PhotoAlbumViewController: MKMapViewDelegate {

    func setupMap() {
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
    }
    
    func addMapAnnotation(_ annotationPin: Pin){
        let centerCoordinate = CLLocationCoordinate2DMake(annotationPin.latitude, annotationPin.longitude)
        
        mapView.centerCoordinate = centerCoordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate

        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .systemRed
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}

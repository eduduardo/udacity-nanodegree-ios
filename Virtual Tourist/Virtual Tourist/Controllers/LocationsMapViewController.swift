//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 26/06/21.
//

import UIKit
import MapKit
import Foundation
import CoreData

class LocationsMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController : DataController!
    
    var annotations = [AnnotationPin]()
    
    struct Map {
        static let centerConfigKey = "map_center"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        loadLocations()
    }
    
    // MARK: Setup functions
    
    func setupMap()
    {
        mapView.delegate = self
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        
        loadCenterFromDefaults()
        setupLongPress()
    }
    
    func setupLongPress()
    {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPoint(longGesture:)))
        mapView.addGestureRecognizer(longGesture)
    }
    
    // MARK: map functions
    
    func loadLocations()
    {
        let pins = try? dataController.fetchAllPins()
        
        for pin in pins ?? [] {
            let annotation = AnnotationPin(pin: pin)
            
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    @objc func addPoint(longGesture: UILongPressGestureRecognizer){
        
        if (longGesture.state == .ended){
            let touchPoint = longGesture.location(in: mapView)
            let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            let geoPosition = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

            CLGeocoder().reverseGeocodeLocation(geoPosition) { (placemarks, error) in
                let pin = Pin(context: self.dataController.viewContext)
                pin.latitude = coordinates.latitude
                pin.longitude = coordinates.longitude
                pin.createdAt = Date()
                pin.totalPages = 0
                pin.title = placemarks?.first?.name ?? "Unknow"
                pin.subtitle = placemarks?.first?.country ?? "Country Unknow"

                self.dataController.save()

                let annotation = AnnotationPin(pin: pin)

                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.region.center
        let zoom = mapView.region.span
        
        saveCenterOnDefaults(center, zoom)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .systemRed
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let annotationPin = view.annotation as! AnnotationPin
            
            performSegue(withIdentifier: "showPhotos", sender: annotationPin.pin)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showPhotos") {
            let photoCollectionController = segue.destination as? PhotoAlbumViewController
            photoCollectionController?.setupPin(sender as! Pin)
        }
    }
    
    // MARK: User Center/Zoom Default
    
    func saveCenterOnDefaults(_ center: CLLocationCoordinate2D, _ zoom: MKCoordinateSpan) {
        let location = [
            "latitude": Double(center.latitude),
            "longitude": Double(center.longitude),
            
            "latitudeDelta": Double(zoom.latitudeDelta),
            "longitudeDelta": Double(zoom.longitudeDelta)
        ]
        
        UserDefaults.standard.setValue(location, forKey: Map.centerConfigKey)
    }
    
    func loadCenterFromDefaults(){
        let storedLocation = UserDefaults.standard.dictionary(forKey: Map.centerConfigKey)
        guard let center = storedLocation as? [String: Double] else {
            return
        }
        
        let centerCoordinates = CLLocationCoordinate2DMake(center["latitude"]!, center["longitude"]!)
        let centerSpan = MKCoordinateSpan(latitudeDelta: center["latitudeDelta"]!, longitudeDelta: center["longitudeDelta"]!)
        
        mapView.setRegion(MKCoordinateRegion(center: centerCoordinates, span: centerSpan), animated: true)
    }
    
}


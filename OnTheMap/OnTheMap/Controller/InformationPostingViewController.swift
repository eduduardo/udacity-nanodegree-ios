//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 19/06/21.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController : SharedViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mediaText: UITextField!
    @IBOutlet weak var stackInputView: UIStackView!
    @IBOutlet weak var finishButtonView: UIButton!
    
    var mapView: MKMapView!
    var coordinates: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationText.delegate = self
        mediaText.delegate = self
        
        setupMap()
    }
    
    // MARK: map methods
    
    func setupMap() {
        mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        
        view.addSubview(mapView)
        view.bringSubviewToFront(finishButtonView)
        
        mapView.isHidden = true
    }
    
    func addMapMarker(latitude: Double, longitude: Double, title: String, subtitle: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        
        self.mapView.addAnnotation(annotation)
        self.mapView.centerCoordinate = coordinate
       
        // map zoom
        
        let region = MKCoordinateRegion( center: coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)

        self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
    }
    
    func getGeoLocation(_ address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self.showAlertModal("Location", "Sorry, no location founded, try again")
                completion(nil, error)
                return
            }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            print("Lat: \(lat), Lon: \(lon)")
            
            completion(location.coordinate, nil)
        }
    }
    
    func toggleMap(){
        stackInputView.isHidden = true
        
        finishButtonView.isHidden = false
        mapView.isHidden = false
    }
    
    func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: input methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard(){
        if mediaText.isFirstResponder {
            mediaText.resignFirstResponder()
        }
        if locationText.isFirstResponder {
            locationText.resignFirstResponder()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        goBack()
    }
    
    @IBAction func findLocationAction(_ sender: Any) {
        let address = locationText.text ?? ""
        
        guard let url = URL(string: self.mediaText.text!), UIApplication.shared.canOpenURL(url) else {
            showAlertModal("Invalid Link", "Please provide a valid link")
            return
        }
        
        hideKeyboard()
        toggleLoadingIndicator(true)
        
        getGeoLocation(address) { location,error in
            self.toggleLoadingIndicator(false)
            
            if error != nil {
                return
            }
            self.toggleMap()
            
            let latitude = location!.latitude
            let longitude = location!.longitude
            let media = self.mediaText.text ?? ""
            
            self.coordinates = location!
            
            DispatchQueue.main.async {
                self.addMapMarker(latitude: latitude, longitude: longitude, title: address, subtitle: media)
            }
        }
    }
    
    @IBAction func finishLocationAction(_ sender: Any) {
        let media = self.mediaText.text ?? ""
        let address = locationText.text ?? ""
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        
        let studentLocation = StudentLocationPost(
            uniqueKey: UdacityAPI.Auth.accountKey,
            firstName: UdacityAPI.Auth.firstName,
            lastName: UdacityAPI.Auth.lastName,
            mapString: address,
            mediaURL: media,
            latitude: latitude,
            longitude: longitude)

        UdacityAPI.shared().addLocation(studentLocationPost: studentLocation) { success, error in
            if error != nil {
                self.showAlertModal("Add Location", "Erro adding location, try again")
                return
            }

            DispatchQueue.main.async {
                self.showAlertModal("Location", "Location added with success!") { (action) in
                    self.goBack()
                }
            }
        }
    }
}

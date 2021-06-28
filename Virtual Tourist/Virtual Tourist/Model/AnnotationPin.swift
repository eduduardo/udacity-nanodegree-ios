//
//  AnnotationPin.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 27/06/21.
//

import Foundation
import MapKit

class AnnotationPin : MKPointAnnotation  {
    
    var pin: Pin
    
    init(pin: Pin){
        self.pin = pin
        super.init()
        self.coordinate = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        self.title = pin.title
        self.subtitle = pin.subtitle
    }
}

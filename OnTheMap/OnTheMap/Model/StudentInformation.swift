//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 19/06/21.
//

import Foundation

struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    
    let createdAt: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}

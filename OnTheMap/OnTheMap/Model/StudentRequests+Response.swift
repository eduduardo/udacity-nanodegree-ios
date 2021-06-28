//
//  StudentRequests+Response.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 20/06/21.
//

import Foundation

struct StudentResponse: Codable {
    let results: [StudentInformation]
}

struct StudentLocationPost: Encodable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

struct PostLocationResponse: Codable {
    let createdAt: String?
    let objectId: String?
}

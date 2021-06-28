//
//  FlickrResponses.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 26/06/21.
//

import Foundation
import UIKit

struct SearchResponse: Codable {
    let photos: Photos
    let stat: String
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [PhotoStruct]
}

struct PhotoStruct: Codable, Equatable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let url_m: String
    let heightM, widthM: Int
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case url_m = "url_m"
        case heightM = "height_m"
        case widthM = "width_m"
    }
}


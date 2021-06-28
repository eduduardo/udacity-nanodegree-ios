//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 19/06/21.
//

import Foundation

struct UdacityUser: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}

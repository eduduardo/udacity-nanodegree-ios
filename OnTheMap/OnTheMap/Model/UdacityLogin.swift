//
//  UdacityLogin.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 18/06/21.
//

import Foundation

struct User: Encodable {
    let username: String
    let password: String
}

struct UdacityLogin: Encodable {
    let udacity: User
}

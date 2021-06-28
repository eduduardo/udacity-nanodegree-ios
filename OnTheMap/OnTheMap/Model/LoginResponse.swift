//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 18/06/21.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

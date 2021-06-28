//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 20/06/21.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}

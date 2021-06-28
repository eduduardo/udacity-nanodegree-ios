//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 18/06/21.
//

import Foundation

class UdacityAPI: NSObject {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
    }
    enum Endpoint {
        
        case login
        case logout
        case signup
        case locations
        case addLocation
        case userInfo
        
        var stringValue: String {
            switch self {
            case .login, .logout:
                return "https://onthemap-api.udacity.com/v1/session"
            case .signup:
                return "https://auth.udacity.com/sign-up"
            case .locations:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
            case .addLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .userInfo:
                return "https://onthemap-api.udacity.com/v1/users/" + Auth.accountKey
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    override init() {
        super.init()
    }
    
    class func shared() -> UdacityAPI {
        struct Singleton {
            static var shared = UdacityAPI()
        }
        return Singleton.shared
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let user = User(username: username, password: password)
        let udacityLogin = UdacityLogin(udacity: user)
        
        Request.POSTRequest(url: Endpoint.login.url, requestParams: udacityLogin, responseType: LoginResponse.self, parseFirstBytes: true) {
            response, error in
            if error != nil {
                completion(false, error)
                return
            }
            Auth.accountKey = response!.account.key
            Auth.sessionId = response!.session.id
            self.getUserInfo()
            completion(true, nil)
        }
    }
    
    func logout(completion: @escaping (Bool, Error?) -> Void){
        Request.DELETERequest(url: Endpoint.logout.url, parseFirstBytes: true) { (success, error) in
            if error != nil {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func getLocations(limit:UInt8 = 100, skip: UInt8 = 0, order: String? = "-updatedAt", uniqueKey: String? = nil, completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        
        Request.GETRequest(url: Endpoint.locations.url, responseType: StudentResponse.self) {response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            completion(response?.results, nil)
        }
    }
    
    func getUserInfo(){
        Request.GETRequest(url: Endpoint.userInfo.url, responseType: UdacityUser.self, parseFirstBytes: true) { response, error in
            if error != nil {
                return
            }
            
            Auth.firstName = response!.firstName
            Auth.lastName = response!.lastName
        }
    }
    
    func addLocation(studentLocationPost: StudentLocationPost, completion: @escaping (Bool, Error?) -> Void){
        Request.POSTRequest(url: Endpoint.addLocation.url, requestParams: studentLocationPost, responseType: PostLocationResponse.self) { response, error in
            if error != nil {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
}

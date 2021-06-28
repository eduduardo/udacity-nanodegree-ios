//
//  Request.swift
//  OnTheMap
//
//  Created by Eduardo Ramos on 18/06/21.
//

import Foundation

class Request {
    class func GETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, parseFirstBytes: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            var dataParsed = data
            
            if parseFirstBytes {
                let range = 5..<data.count
                dataParsed = data.subdata(in: range)
            }
            
            do {
                let response = try JSONDecoder().decode(ResponseType.self, from: dataParsed)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func POSTRequest<RequestParams: Encodable, ResponseType: Decodable>(url: URL, requestParams: RequestParams, responseType: ResponseType.Type, parseFirstBytes: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONEncoder().encode(requestParams)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        request.httpBody = jsonString.data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request){
            data,response,error in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            var dataParsed = data
            
            if parseFirstBytes {
                let range = 5..<data.count
                dataParsed = data.subdata(in: range)
            }
            
            do {
                let response = try JSONDecoder().decode(responseType, from: dataParsed)
                completion(response, nil)
            } catch {
                handleError(dataParsed, completion)
            }
            
        }
        task.resume()
    }
    
    class func DELETERequest(url: URL, parseFirstBytes: Bool = false, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            var dataParsed = data
            
            if parseFirstBytes {
                let range = 5..<data.count
                dataParsed = data.subdata(in: range)
            }
            
            print(String(data: dataParsed, encoding: .utf8)!)
            
            completion(true, nil)
        }
        task.resume()
    }
    
    class func handleError<ResponseType: Decodable>(_ data: Data, _ completion: (ResponseType?, Error?) -> ()) {
        do {
            let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
            completion(nil, response)
        } catch {
            completion(nil, error)
        }
    }
}

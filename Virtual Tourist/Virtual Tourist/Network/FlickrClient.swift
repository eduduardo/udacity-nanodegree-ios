//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 26/06/21.
//

import Foundation

class FlickrClient {
    static let API_KEY = "4a5248dd02c8fd6b95ef97fa2772a644"
    static let API_SECRET = "" // not need for this project
    
    static let shared = FlickrClient()
    
    enum Endpoint {
        static let base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        static let radius = 20
        static let perPage = 20
        case searchPhotos(Double, Double, Int)
        
        var urlString: String {
            switch self {
            case .searchPhotos(let latitude, let longitude, let page):
                return Endpoint.base +
                    "&api_key=\(FlickrClient.API_KEY)" +
                    "&lat=\(latitude)" +
                    "&lon=\(longitude)" +
                    "&page=\(page)" +
                    "&radius=\(Endpoint.radius)" +
                    "&per_page=\(Endpoint.perPage)" +
                    "&format=json&nojsoncallback=1&extras=url_m"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    func getRandomPage(totalPages: Int16) -> Int {
        if totalPages == 0 { // if the first request, return the first page
            return 1
        }
        
        return Int.random(in: 1...Int(totalPages))
    }
    
    func getPhotos(latitude: Double, longitude: Double, totalPages: Int16, completion: @escaping ([PhotoStruct], Int, Error?) -> Void){
        let randomPage = getRandomPage(totalPages: totalPages)
        let searchUrl = Endpoint.searchPhotos(latitude, longitude, randomPage)
        Request.GETRequest(url: searchUrl.url, responseType: SearchResponse.self) { response, error in
            if let response = response {
                completion(response.photos.photo, response.photos.pages, nil)
            } else {
                completion([], 0, error)
            }
        }
    }
    
    class func donwloadImage(mediaUrl: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: mediaUrl) else {
            completion(nil, nil)
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
}

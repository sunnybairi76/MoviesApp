//
//  DataManager.swift
//  Assigntment
//
//  Created by Bairi Akash on 24/08/23.
//

import Foundation
import UIKit

class MovieManager {
    
    static let shared = MovieManager()
    private init() {    }
    
    static func fetchPopularMovies(pageNumber page : Int, completionhandler: @escaping (APIresponseData?)->(Void)) {
        
        let headers = ["accept": "application/json"]
        let URLString = "https://api.themoviedb.org/3/movie/now_playing?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page="
        
        let apiURLString = URLString + String(page)
        
        let url = URL(string: apiURLString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            guard error == nil, let jsonData = data else{
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Status code not 200")
                return
            }
            
            let responseData = try? JSONDecoder().decode(APIresponseData.self, from: jsonData)
            
            completionhandler(responseData)
            
        }.resume()
        
    }
    
    static func fetchPopularMoviesWithTitle(titleTyped title: String, pageNumber page : Int = 1, completionhandler: @escaping ([Film]?)->(Void)) {
        
        let headers = ["accept": "application/json"]
        let URLString = "https://api.themoviedb.org/3/search/movie?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page="
        
        let apiURLString = URLString + String(page) + "&query=" + title
       
        let url = URL(string: apiURLString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            guard error == nil, let jsonData = data else{
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Status code not 200")
                return
            }
            
            let responseData = try? JSONDecoder().decode(APIresponseData.self, from: jsonData)
           
            completionhandler(responseData?.results)
            
        }.resume()
        
    }
    
    
    
    static func fetchMoviePoster(from apiURLString: String,completionHandler: @escaping (UIImage?) -> (Void)){
        
        let url = URL(string: apiURLString)!
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data,response,error) in
            guard error == nil, let imageData = data else{
                completionHandler(nil)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                completionHandler(nil)
                return
            }
            completionHandler(image)
        }.resume()
    }
}

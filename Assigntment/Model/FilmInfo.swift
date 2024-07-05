//
//  MovieInfo.swift
//  Assigntment
//
//  Created by Bairi Akash on 24/08/23.
//

import Foundation

struct APIresponseData :  Codable {
    var results: [Film]
    var total_pages: Int?
}

struct Film: Codable {
    var title: String?
    var overview: String?
    var popularity: Double?
    var release_date: String?
    var vote_average: Double?
    var poster_path: String?
    
}

enum HTTPMethod: String {
    case GET
}

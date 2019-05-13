//
//  APIRequest.swift
//  DeezerExercice
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation

let baseUrl : String = "https://api.deezer.com"
let search  : String = "/search"
let artist  : String = "/artist"
let album  : String = "/album"
let track  : String = "/track"


enum RequestType{
    case album
    case artist
    case track
}

enum RequestMethod : String{
    case albums = "albums"
    case tracks = "tracks"
    case empty = ""
}

enum SearchType {
    case album
    case artist
    case track
    case other
}

enum SearchOrder : String{
    case ranking = "RANKING"
    case track_asc = "TRACK_ASC"
    case track_desc = "TRACK_DESC"
    case artist_asc = "ARTIST_ASC"
    case artist_desc = "ARTIST_DESC"
    case album_asc = "ALBUM_ASC"
    case album_desc = "ALBUM_DESC"
    case rating_asc = "RATING_ASC"
    case rating_desc = "RATING_DESC"
    case duration_asc = "DURATION_ASC"
    case duration_desc = "DURATION_DESC"
}

class DZRRequest {
    
    func createSearchRequest(type: SearchType, order: SearchOrder, query: String, limit: String) -> URL{
        
        var url = ""

        switch type {
        case .artist:
            url = baseUrl + search + artist + "?q=\(query)" + "&limit=\(limit)" + "&order=\(order.rawValue)"
        case .album:
            url = baseUrl + search + album + "?q=\(query)" + "&limit=\(limit)" + "&order=\(order.rawValue)"
        case .track:
            url = baseUrl + search + track + "?q=\(query)" + "&limit=\(limit)" + "&order=\(order.rawValue)"
        case .other:
            url = baseUrl + search + "?q=\(query)" + "&limit=\(limit)" + "&order=\(order.rawValue)"
        }
        
        let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        return URL(string: escapedUrl!)!
    }
    
    func createRequest(type : RequestType, method : RequestMethod, id : String) -> URL{
        
        var url = ""
        
        switch type {
        case .artist:
            url = baseUrl + artist + "/\(id)/" + "\(method.rawValue)"
        case .album:
            url = baseUrl + album + "/\(id)/" + "\(method.rawValue)"
        case .track:
            url = baseUrl + track + "/\(id)/" + "\(method.rawValue)"
        }
        
        let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        return URL(string: escapedUrl!)!
    }

}

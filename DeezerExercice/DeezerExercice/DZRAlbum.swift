//
//  DZRAlbum.swift
//  DeezerExercice
//
//  Created by AKIN on 12.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation

struct DZRAlbum {
    
    let albumIdentifier  : String
    let albumTitle       : String
    let coverPictureUrl  : String
    let albumFans        : String
    let duration         : String
    let releaseDate      : String
    let artistName       : String
    let tracks           : [DZRTrack]
    let mostPopularTrack : String
    
    init(id : Int, title : String, cover : String, fans : Int, duration : Int, date : String, artistName : String, tracks : [DZRTrack], mostPopular : String){
        self.albumIdentifier  = String(id)
        self.albumTitle       = title
        self.coverPictureUrl  = cover
        self.albumFans        = String(fans)
        self.duration         = String(duration)
        self.releaseDate      = date
        self.artistName       = artistName
        self.tracks           = tracks
        self.mostPopularTrack = mostPopular
    }
    
    init?(json: JsonDictionary, tracks : [DZRTrack], mostPopular : String) {
        guard let id         = json["id"] as? Int else { return nil }
        guard let title      = json["title"] as? String else { return nil }
        guard let cover      = json["cover_big"] as? String else { return nil }
        guard let fans       = json["fans"] as? Int else { return nil }
        guard let duration   = json["duration"] as? Int else { return nil }
        guard let date       = json["release_date"] as? String else { return nil }
        guard let artistName = (json["artist"] as! JsonDictionary)["name"] as? String else { return nil }
        
        self.init(id: id, title: title, cover: cover, fans: fans, duration: duration, date: date, artistName: artistName, tracks : tracks, mostPopular : mostPopular)
    }
    
}

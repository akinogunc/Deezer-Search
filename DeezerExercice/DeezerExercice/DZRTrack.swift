//
//  DZRTrack.swift
//  DeezerExercice
//
//  Created by AKIN on 12.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation

struct DZRTrack {
    
    let trackIdentifier  : String
    let trackTitle       : String
    let previewUrl       : String
    let artistName       : String
    let albumName        : String
    
    init(id : Int, title : String, preview : String, artistName : String, albumName : String){
        self.trackIdentifier  = String(id)
        self.trackTitle       = title
        self.previewUrl       = preview
        self.artistName       = artistName
        self.albumName        = albumName
    }
    
    init?(json: JsonDictionary, artist : String, album : String) {
        guard let id         = json["id"] as? Int else { return nil }
        guard let title      = json["title"] as? String else { return nil }
        guard let preview    = json["preview"] as? String else { return nil }
        self.init(id: id, title: title, preview: preview, artistName: artist, albumName : album)
    }
    
}


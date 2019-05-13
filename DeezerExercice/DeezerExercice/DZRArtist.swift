//
//  DZRArtist.swift
//  DeezerExercice
//
//  Created by AKIN on 9.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation

struct DZRArtist {
    
    let artistIdentifier : String
    let artistName       : String
    let artistPictureUrl : String
    let fans             : String

    init(id : Int, name : String, picture : String, fan : Int){
        self.artistIdentifier   = String(id)
        self.artistName         = name
        self.artistPictureUrl   = picture
        self.fans               = String(fan)
    }
    
    init?(json: JsonDictionary) {
        guard let id        = json["id"] as? Int else { return nil }
        guard let fan       = json["nb_fan"] as? Int else { return nil }
        guard let name      = json["name"] as? String else { return nil }
        guard let picture   = json["picture_big"] as? String else { return nil }
        self.init(id : id, name : name, picture : picture, fan : fan)
    }

}

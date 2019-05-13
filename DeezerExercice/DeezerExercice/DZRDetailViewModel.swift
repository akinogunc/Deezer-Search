//
//  DZRDetailViewModel.swift
//  DeezerExercice
//
//  Created by AKIN on 12.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation
import UIKit

enum DetailMode {
    case albumDetail
    case artistDetail
    case playlistDetail
}

protocol DetailViewModelDelegate {
    func dataReady()
}

class DZRDetailViewModel {
    
    var album : DZRAlbum? = nil
    var apiService = DZRService()
    let apiRequest = DZRRequest()
    var delegate: DetailViewModelDelegate?
    
    init(id : String, type : DetailMode) {
        getFirstAlbumWithArtistID(id: id, completion: {
            self.delegate?.dataReady()
        })
    }
    
    func getFirstAlbumWithArtistID(id: String, completion: @escaping () -> Void) {
        
        let request = apiRequest.createRequest(type: .artist, method: .albums, id: id)
        
        self.apiService.makeApiRequestWith(url: request, completion:{response in
            
            switch response {
            case .success(let json):
                
                guard let data = json["data"] as? [Any] else {return}
                if data.count == 0 {return}
                guard let firstAlbum = data[0] as? JsonDictionary else {return}
                guard let id = firstAlbum["id"] as? Int else {return}
                
                self.getAlbumFrom(id: id){
                    completion()
                }
                
            case .failure:
                completion()
            case .notConnectedToInternet:
                completion()
            }
            
        })
    }

    func getAlbumFrom(id: Int, completion: @escaping () -> Void){
        
        let request = apiRequest.createRequest(type: .album, method: .empty, id: String(id))
        
        self.apiService.makeApiRequestWith(url: request, completion:{response in
            
            switch response {
            case .success(let json):

                if let album = DZRAlbum(json: json, tracks: self.parseTracksFromAlbum(json: json), mostPopular : self.getMostPopularTrack(json: json)){
                    self.album = album
                }
                
                completion()
            case .failure:
                completion()
            case .notConnectedToInternet:
                completion()
            }
            
        })

    }
    
    func parseTracksFromAlbum(json : JsonDictionary) -> [DZRTrack]{
        
        var tracks = [DZRTrack]()
        
        let artistName = (json["artist"] as! JsonDictionary)["name"] as? String ?? ""
        let albumName  = json["title"] as? String ?? ""
        
        if let tracksData = (json["tracks"] as! JsonDictionary)["data"] as? NSArray{
            for i in 0..<tracksData.count{
                if let track = DZRTrack(json: tracksData[i] as! JsonDictionary, artist: artistName, album: albumName){
                    tracks.append(track)
                }
            }
        }

        return tracks
    }
    
    func getMostPopularTrack(json : JsonDictionary) -> String{
        if let tracksData = (json["tracks"] as! JsonDictionary)["data"] as? NSArray{
            let sortedResults = (tracksData as NSArray).sortedArray(using: [NSSortDescriptor(key: "rank", ascending: false)]) as! [[String:AnyObject]]
            return sortedResults.first!["title"] as! String
        }else{
            return ""
            
        }
    }

}

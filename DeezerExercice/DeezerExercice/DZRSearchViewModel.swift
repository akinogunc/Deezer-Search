//
//  DZRArtistSearchViewModel.swift
//  DeezerExercice
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRSearchViewModel {

    var artists = [DZRArtist]()
    var apiService = DZRService()
    let apiRequest = DZRRequest()
    
    func searchArtists(query: String, completion: @escaping (ServiceResponse) -> Void) {
        
        let request = apiRequest.createSearchRequest(type: .artist, order: .ranking, query: query, limit: "50")

        self.apiService.makeApiRequestWith(url: request, completion:{response in
            
            switch response {
            case .success(let json):
                
                self.parseArtists(json: json)
                
                if self.artists.count == 0{
                    completion(.failure)
                    break
                }
                
                completion(.success(json: JsonDictionary()))
                
            case .failure:
                completion(.failure)
            case .notConnectedToInternet:
                completion(.notConnectedToInternet)
            }

        })
    }

    func parseArtists(json: JsonDictionary){
        
        artists.removeAll()
        
        if let data = json["data"] {
            for object in (data as? [Any])!{
                if let artist = DZRArtist(json: object as! JsonDictionary){
                    artists.append(artist)
                }
            }
        }
    }
    
    func clearArtists(completion: @escaping () -> Void) {
        artists.removeAll()
        completion()
    }
}

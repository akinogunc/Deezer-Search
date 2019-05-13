//
//  APIRequest.swift
//  DeezerExercice
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation

typealias JsonDictionary = [String : Any]

enum ServiceResponse {
    case success(json: JsonDictionary)
    case failure
    case notConnectedToInternet
}

class DZRService {
    
    func makeApiRequestWith(url: URL, completion: @escaping (ServiceResponse) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            var json: Any?
            
            guard error == nil else {
                if let error = error as NSError?, error.code == NSURLErrorNotConnectedToInternet{
                    completion(.notConnectedToInternet)
                } else {
                    completion(.failure)
                }
                return
            }
            
            if let data = data {
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                } catch {
                    completion(.failure)
                    return
                }
            }
            
            guard let jsonDict = json as? JsonDictionary else {
                completion(.failure)
                return
            }
            
            if jsonDict["error"] != nil {
                completion(.failure)
                return
            }

            //print(jsonDict)
            completion(.success(json: jsonDict))
            
        }
        task.resume()
        
    }

}


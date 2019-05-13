//
//  DZRImageCache.swift
//  DeezerExercice
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation
import UIKit

class DZRImageCache: NSObject {
    
    class func path(name: String) -> String {
        let finalPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        return finalPath + name
    }
    
    class func getImage(url: String, completion: @escaping(UIImage) -> Void) {
        guard let localImage = UIImage(contentsOfFile: self.path(name: url)) else {
            DispatchQueue.global(qos: .background).async {
                let imageData = NSData(contentsOf: URL(string: url)!)
                DispatchQueue.main.async( execute: {
                    imageData?.write(toFile: self.path(name: url), atomically: true)
                    if imageData != nil{
                        let finalImage = UIImage(data: imageData! as Data)
                        completion(finalImage!)
                    }
                })
            }
            return
        }
        completion(localImage)
    }
}

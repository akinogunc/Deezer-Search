//
//  DZRTrackTests.swift
//  DeezerExerciceTests
//
//  Created by AKIN on 13.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import XCTest

class DZRTrackTests: XCTestCase {

    var apiService = DZRService()
    let apiRequest = DZRRequest()
    
    func testInitTrack() {
        
        let request = apiRequest.createRequest(type: .track, method: .empty, id: "3135556")
        var track : DZRTrack?
        
        let expectation = self.expectation(description: "1")
        
        self.apiService.makeApiRequestWith(url: request, completion:{response in
            
            switch response {
            case .success(let json):
                
                track = DZRTrack(json: json, artist: "", album: "")
                expectation.fulfill()
                
            case .failure:break
            case .notConnectedToInternet:break
            }
            
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertTrue(track != nil)
        XCTAssertTrue(track?.trackIdentifier == "3135556")
        XCTAssertTrue(track?.trackTitle == "Harder Better Faster Stronger")
        XCTAssertTrue(track?.previewUrl == "https://cdns-preview-d.dzcdn.net/stream/c-deda7fa9316d9e9e880d2c6207e92260-5.mp3")
        
    }

}

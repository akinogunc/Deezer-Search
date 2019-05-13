//
//  DZRAlbumTests.swift
//  DeezerExerciceTests
//
//  Created by AKIN on 13.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import XCTest

class DZRAlbumTests: XCTestCase {
    
    var apiService = DZRService()
    let apiRequest = DZRRequest()
    let vm = DZRDetailViewModel(id: "", type: .albumDetail)
    
    func testInitAlbum() {
        
        let request = apiRequest.createRequest(type: .album, method: .empty, id: "302127")
        var album : DZRAlbum?
        
        let expectation = self.expectation(description: "1")

        self.apiService.makeApiRequestWith(url: request, completion:{response in
            
            switch response {
            case .success(let json):
                
                album = DZRAlbum(json: json, tracks: self.vm.parseTracksFromAlbum(json: json), mostPopular : self.vm.getMostPopularTrack(json: json))
                expectation.fulfill()

            case .failure:break
            case .notConnectedToInternet:break
            }
            
        })

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertTrue(album != nil)
        XCTAssertTrue(album?.albumTitle == "Discovery")
        XCTAssertTrue(album?.albumIdentifier == "302127")
        XCTAssertTrue(album?.artistName == "Daft Punk")
        XCTAssertTrue(album?.coverPictureUrl == "https://e-cdns-images.dzcdn.net/images/cover/2e018122cb56986277102d2041a592c8/500x500-000000-80-0-0.jpg")
        XCTAssertTrue(album?.albumFans == "194936")
        XCTAssertTrue(album?.tracks.count == 14)

    }

}

//
//  APIServiceTests.swift
//  DeezerExerciceTests
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import XCTest

class DZRServiceTests: XCTestCase {

    let apiRequest = DZRRequest()
    let apiService = DZRService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessfulRequest() {

        let searchRequest = apiRequest.createSearchRequest(type: .artist, order: .ranking, query: "Tame", limit: "50")

        let expectation = self.expectation(description: "1")
        var expextedJson = JsonDictionary()

        apiService.makeApiRequestWith(url: searchRequest, completion:{response in
            
            switch response {
            case .success(let json):
                expextedJson = json
                expectation.fulfill()
            case .failure: break
            case .notConnectedToInternet: break
            }
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        let artistsArray = expextedJson["data"] as! NSArray
        let firstArtist = artistsArray[0] as! [String : Any]

        XCTAssertEqual(artistsArray.count, 50)
        XCTAssertEqual(firstArtist["name"] as! String, "Tame Impala")
    }

    func testFailedRequest() {
        
        let searchRequest = apiRequest.createSearchRequest(type: .artist, order: .ranking, query: " ", limit: "50")
        
        let expectation = self.expectation(description: "1")
        var result = ""
        
        apiService.makeApiRequestWith(url: searchRequest, completion:{response in
            
            switch response {
            case .success(_): break
            case .failure:
                result = "failed"
                expectation.fulfill()
            case .notConnectedToInternet:
                result = "internet"
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(result, "failed")
    }

    func testAlbumsRequest() {
        
        let request = apiRequest.createRequest(type: .artist, method: .albums, id: "134790")

        let expectation = self.expectation(description: "1")
        var expextedJson = JsonDictionary()
        
        apiService.makeApiRequestWith(url: request, completion:{response in
            
            switch response {
            case .success(let json):
                expextedJson = json
                expectation.fulfill()
            case .failure: break
            case .notConnectedToInternet: break
            }
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        let albumsArray = expextedJson["data"] as! NSArray
        let firstAlbum = albumsArray[0] as! [String : Any]
        
        XCTAssertEqual(firstAlbum["title"] as! String, "Currents B-Sides & Remixes")
    }

}

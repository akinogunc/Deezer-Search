//
//  APIRequestTests.swift
//  DeezerExerciceTests
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import XCTest

class DZRRequestTests: XCTestCase {

    let apiRequest = DZRRequest()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchRequest() {

       let searchRequest = apiRequest.createSearchRequest(type: .artist, order: .ranking, query: "Tame Impala", limit: "50")
        XCTAssertTrue(searchRequest == URL(string:"https://api.deezer.com/search/artist?q=Tame%20Impala&limit=50&order=RANKING"))

        let searchRequest2 = apiRequest.createSearchRequest(type: .other, order: .ranking, query: "eminem", limit: "50")
        XCTAssertTrue(searchRequest2 == URL(string:"https://api.deezer.com/search?q=eminem&limit=50&order=RANKING"))

    }

    func testRequest() {
        
        let request = apiRequest.createRequest(type: .artist, method: .albums, id: "134790")
        XCTAssertTrue(request == URL(string:"https://api.deezer.com/artist/134790/albums"))

    }
}

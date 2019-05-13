//
//  DZRSearchViewModelTests.swift
//  DeezerExerciceTests
//
//  Created by AKIN on 13.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import XCTest

class DZRSearchViewModelTests: XCTestCase {

    let svm = DZRSearchViewModel()
    
    func testSearch() {
        
        let expectation = self.expectation(description: "1")

        svm.searchArtists(query: "travis", completion: {_ in 
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)

        let artist1 = svm.artists[0]
        let artist2 = svm.artists[1]

        XCTAssertTrue(svm.artists.count == 50)
        XCTAssertTrue(artist1.artistName == "Travis Scott")
        XCTAssertTrue(artist2.artistName == "Travis")

    }

    func testEmptySearch() {
        
        let expectation = self.expectation(description: "1")
        
        svm.searchArtists(query: " ", completion: {_ in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertTrue(svm.artists.count == 0)
        
    }

    func testNoResultSearch() {
        
        let expectation = self.expectation(description: "1")
        
        svm.searchArtists(query: "fhjsadgfhjasdfg", completion: {_ in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertTrue(svm.artists.count == 0)
        
    }

}

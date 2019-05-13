//
//  DZRArtistTest.swift
//  DeezerExerciceTests
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import XCTest

class DZRArtistTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitWithDict() {

        let testDict =  [ "id" : 1033,
            "link" : "http://www.deezer.com/artist/1033",
            "name" : "Alain Souchon",
            "nb_albums" : "49",
            "nb_fan" : 60625,
            "picture" : "http://api.deezer.com/artist/1033/image",
            "radio" : "1",
            "tracklist" : "http://api.deezer.com/artist/1033/top?limit=50",
            "type" : "artist"] as [String : Any]

        let artist = DZRArtist(json : testDict)!

        XCTAssertTrue(artist.artistIdentifier == "1033")
        XCTAssertTrue(artist.artistName == "Alain Souchon")
        XCTAssertTrue(artist.artistPictureUrl == "http://api.deezer.com/artist/1033/image")
        XCTAssertTrue(artist.fans == "60625")

    }

    func testInitWithBrokenDict() {
        
        let testDict =  [ "link" : "http://www.deezer.com/artist/1033",
                          "name" : "Alain Souchon",
                          "nb_albums" : "49",
                          "nb_fan" : 60625,
                          "picture" : "http://api.deezer.com/artist/1033/image",
                          "radio" : "1",
                          "tracklist" : "http://api.deezer.com/artist/1033/top?limit=50",
                          "type" : "artist"] as [String : Any]
        
        let artist = DZRArtist(json : testDict)
        
        XCTAssertTrue(artist == nil)
        
    }

}

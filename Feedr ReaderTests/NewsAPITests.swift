//
//  Feedr_ReaderTests.swift
//  Feedr ReaderTests
//
//  Created by Joshua Fredrickson on 10/9/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import XCTest
@testable import Feedr_Reader
//@testable import NewsAPI

class Feedr_ReaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_updateHeadlines() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        /*let api = NewsAPI.shared
        
        api.updateHeadlines(from: "bbc-news")
        let json = api.apiRequestResults
        XCTAssert(json[api.keyStatus] != nil, "NewsAPI status not found in json")
        XCTAssert(json[api.keySortBy] != nil, "NewsAPI sortBy not found in json")
        XCTAssert(json[api.keySource] != nil, "NewsAPI source not found in json")
        XCTAssert(json[api.keyArticles] != nil, "NewsAPI articles not found in json")
        //let articles = json[api.keyArticles]
        */
    }
    
}

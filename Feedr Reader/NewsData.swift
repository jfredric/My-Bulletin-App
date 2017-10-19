//
//  Data.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/17/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation

enum DataError {
    
}

class NewsData {
    private let defaultStartCount = 20
    
    private var topStories: [NewsStory] = []
    private var searchResults: [NewsStory] = []
    private var sources: [NewsAPI] = []
    private var updateFeedView: (() -> Void)? //update callback
    private var updateSearchView: (() -> Void)? //update callback for search
    
    // MARK: Singleton
    static let sharedInstance = NewsData()
    private init() {
        sources.append(NytNewsAPI.sharedInstance)
    }
    
    // MARK: Table functions
    
    // Count
    public var topCount: Int {
        get {
            return topStories.count
        }
    }
    public var searchCount: Int {
        get {
            return searchResults.count
        }
    }
    
    // Index
    func getTopStory(at: Int) -> NewsStory {
        return topStories[at]
    }
    
    func getSearchStory(at: Int) -> NewsStory {
        return searchResults[at]
    }
    
    // initializing the call backs to update the table views
    func setFeedCallBack(with callback: @escaping () -> Void) {
        updateFeedView = callback
    }
    
    func setSearchCallBack(with callback: @escaping () -> Void) {
        updateSearchView = callback
    }
    
    // are we still getting data for top stories
    func isRequestingTop() -> Bool {
        for source in sources {
            if !source.isRequestingTop() {
                return false
            }
        }
        return true
    }
    
    // are we still getting data for top stories
    func isRequestingSearchResults() -> Bool {
        for source in sources {
            if source.isRequestingSearchResults() {
                return true
            }
        }
        return false
    }
    
    func requestTopStories() {
        // Call API's to fetch data
        for source in sources {
            try! source.requestTopStories(20, startingAt: 0, updateData: { (stories) in
                self.topStories.append(contentsOf: stories)
                //sort data here?
                //update tableview
                if self.updateFeedView != nil {
                    self.updateFeedView!()
                } else {
                    // error here...
                }
            })
        }
    }
    
    func search(forString: String) {
        //func searchStories(_ count: Int, startingAt: Int, search: String?, updateData: @escaping ([NewsStory]) -> Void) throws {
        
        // Call API's to fetch data
        // sources.append(NytNewsAPI.sharedInstance)
        searchResults = []
        var searchString: String? = forString
        if forString == "" {
            searchString = nil
        }
        for source in sources {
            try! source.searchStories(10, startingAt: 0, search: searchString, updateData: { (stories) in
                self.searchResults.append(contentsOf: stories)
                //sort data here?
                //update tableview
                if self.updateSearchView != nil {
                    self.updateSearchView!()
                }
            })
        }
    }
    
}

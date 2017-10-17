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
    
    private var newsStories: [NewsStory] = []
    private var sources: [NewsAPI] = []
    private var updateFeedView: (() -> Void)? //update callback
    
    static let sharedInstance = NewsData()
    private init() {}
    
    public var count: Int {
        get {
            return newsStories.count
        }
    }
    
    func getStory(at: Int) -> NewsStory {
        return newsStories[at]
    }
    
    func setFeedCallBack(with callback: @escaping () -> Void) {
        updateFeedView = callback
    }
    
    func loadInitialData() {
        // Call API's to load data
        sources.append(NytNewsAPI.sharedInstance)
        
        for source in sources {
            try! source.requestTopStories(20, startingAt: 0, updateData: { (stories) in
                self.newsStories.append(contentsOf: stories)
                //sort data here?
                //update tableview
                if self.updateFeedView != nil {
                    self.updateFeedView!()
                }
            })
            
        }
        
    }
    
    func loadNext(_ count: Int) {
        
    }
    
}

//
//  NewsAPI.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/16/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation

enum NewsAPIError: Error {
    case negativeCount, negativeStart
    
}

protocol NewsAPI {
    func isRequestingTop() -> Bool
    func isRequestingSearchResults() -> Bool
    func requestTopStories(_ count: Int, startingAt: Int, updateData: @escaping ([NewsStory]) -> Void) throws
    func searchStories(_ count: Int, startingAt: Int, search: String?, updateData: @escaping ([NewsStory]) -> Void) throws
}

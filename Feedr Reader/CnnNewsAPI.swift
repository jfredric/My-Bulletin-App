//
//  NewAPI.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/16/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation

/*class CnnNewsAPI: NewsAPI {
    
    //MARK: CONSTANTS
    //static URL Components
    private let apiKey = "3jvnh65885uwe5v63pvjwfuy" //cnn
    private let searchEndPoint = "https://services.cnn.com/newsgraph/search/"
    private let queryType = "type:article/"
    private let queryLanguage = "language:en/"
    private let querySortBy = "sort:firstPublishDate,desc/"
    private let queryHasImage = "hasImage:true/"
    
    //Query Keys
    private let queryKeyValueTerminator = "/"
    private let queryKeyResultCount = "rows:"
    private let queryKeyStartAt = "start:"
    private let queryKeyTopic = "section:"
    //possible Keyword or tags
    private let queryDescription = "description:" //value must be wrapped in quotes
    
    //parameter keywords
    private let paramAPIKey = "api_key="
    
    //JSON RootKeys
//    let keyStatus = "status:"
//    let keySource = "source:"
//    let keySortBy = "sortBy:"
//    let keyArticles = "articles:"
    
    
    //MARK: PROPERTIES
    var apiRequestResults: [String:AnyObject] = [:]
    
    
    //MARK: SINGLETONE INSTANCE
    static let shared = CnnNewsAPI()
    
    private init() {}
    
    
    //MARK: FUNCTIONS
    func request(_ count: Int, startingAt: Int, forTopic: String?, containing: String?, withTags: [String], updateData: ([NewsStory]) -> Void) throws{
        print("Forming request for CNN (ignoring contains and tags).")
        
        // check input
        if count < 0 {
            throw NewsAPIError.negativeStart
        }
        if startingAt < 0 {
            throw NewsAPIError.negativeCount
        }

        // example API call
        // https://services.cnn.com/newsgraph/search/type:article/section:tech/language:en/rows:10/start:0/lastPublishDate,desc?api_key=3jvnh65885uwe5v63pvjwfuy
        // Setup the URL Request...
        
        // set up query key:value's
        var urlString = searchEndPoint + queryType + queryLanguage + querySortBy + queryHasImage
        // number of results to return
        urlString = urlString + queryKeyResultCount + String(count) + queryKeyValueTerminator
        // result to start at
        urlString = urlString + queryKeyStartAt + String(startingAt) + queryKeyValueTerminator
        // result to start at
        urlString = urlString + queryKeyStartAt + String(startingAt) + queryKeyValueTerminator
        
        // add contains and tags here
        
        // set up parameters
        urlString = urlString + "?" + paramAPIKey + apiKey
        
        
        guard let requestURL = URL(string: urlString) else {
            throw NewsAPIError.badlyFormatedURL
        }
        
        let request = URLRequest(url: requestURL)

        /*
        // Setup the URL Session...
        let session = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            // Process the Response...
            
            
            if error != nil {
                // Handle Error and Alert User
                print("Networking Error: \(String(describing: error) )")
            } else {
                print("JSON Received...File Size: \(data!) \n")
                //ready for JSONSerialization
                do {
                    // Serialize Json....
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    self.apiRequestResults = jsonObject
                    
                    // Else take care of error
                } catch {
                    // Handle Error
                    print("Error deserializing JSON: \(error)")
                }
            }
        }
        
        // Execute the URL Task
        session.resume()*/
    }
    
    func requestNext(_ count: Int) {
        <#code#>
    }
    
}*/

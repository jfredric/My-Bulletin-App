//
//  NytNewsAPI.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/17/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation

//https://developer.nytimes.com/

class NytNewsAPI: NewsAPI {
    //MARK: CONSTANTS
    
    // static URL Components
    private let apiKey = "6745696533b04c17a90c215f1106f56b" //cnn
    private let searchEndPoint = "https://api.nytimes.com/svc/search/v2/articlesearch.json?"
    private let topStoriesEndPoint = "https://api.nytimes.com/svc/topstories/v2/home.json?"
    
    // parameter keywords
    private let paramAPIKey = "api-key="
    
    // JSON RootKeys
    let keyStatus = "status"
    let keyNumResults = "num_results"
    let keyResults = "results"
    
    // JSON Story Keys
    let keyHeadline = "title"
    let keyDescription = "abstract"
    let keyURL = "url"
    
    // JSON Media Keys & values
    let keyMedia = "multimedia"
    let keyImageURL = "url"
    let keyImageType = "type"
    let valueImageNormal = "normal"
    let keyImageHeight = "height"
    
    
    //MARK: SINGLETONE INSTANCE
    static let sharedInstance = NytNewsAPI()
    
    private init() {}
    
    
    //MARK: NEWSAPI FUNCTIONS
    
    func requestTopStories(_ count: Int, startingAt: Int, updateData: @escaping ([NewsStory]) -> Void) throws {
        print("Forming request for NYT top stories.")
        
        // check input
        if count < 0 {
            throw NewsAPIError.negativeStart
        }
        if startingAt < 0 {
            throw NewsAPIError.negativeCount
        }

        // Setup the URL Request...
        // format: https://api.nytimes.com/svc/topstories/v2/{section}.{response-format}?api-key={your-api-key}
        
        // set up url
        var urlString = topStoriesEndPoint

        // set up parameters
        urlString = urlString + paramAPIKey + apiKey
        
        guard let requestURL = URL(string: urlString) else {
            throw NetworkErrors.badlyFormatedURL
        }
    
        // Setup the URL Session...
        let session = URLSession.shared.dataTask(with: requestURL ) {
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
                    var stories: [NewsStory] = []
                    
                    let results = jsonObject[self.keyResults] as! [[String:AnyObject]]
                    for story in results {
                        let headline = story[self.keyHeadline] as! String
                        let description = story[self.keyDescription] as! String
                        let url = story[self.keyURL] as! String
                        let newStory = NewsStory(headline: headline, description: description, url: url)
                        
                        let images = story[self.keyMedia] as! [[String:AnyObject]]
                        if images.count != 0 {
                            // get best picture
                            var bestHeight = 0
                            var bestImageURL = ""
                            for image in images { //look for normal, use biggest otherwise
                                let imageType = image[self.keyImageType] as! String
                                if imageType == self.valueImageNormal {
                                    bestImageURL = image[self.keyImageURL] as! String
                                    break
                                } else {
                                    let imageHeight = image[self.keyImageHeight] as! Int
                                    if imageHeight > bestHeight {
                                        bestHeight = imageHeight
                                        bestImageURL = image[self.keyImageURL] as! String
                                    }
                                }
                            }
                            print("(h",newStory.headline,")")
                            newStory.imageURL = bestImageURL
                            print(newStory.imageURL)
                            newStory.downloadImage()
                            if newStory.image == nil {
                                print("image not downloaded")
                            }
                        }
                        stories.append(newStory)
                    }
                    DispatchQueue.main.async {
                        updateData(stories)
                    }
                } catch {
                    // Handle Error
                    print("Error deserializing JSON: \(error)")
                }
            }
        }
        
        // Execute the URL Task
        session.resume()
    } // end of requestTopStories func
    
    //MARK: END OF CLASS
}

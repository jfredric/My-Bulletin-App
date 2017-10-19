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
    private let staticContentEndPoint = "https://static01.nyt.com/"
    
    // parameter keywords
    private let paramAPIKey = "api-key="
    private let paramSearch = "q="
    private let paramSort = "sort="
    private struct valueSort {
        static let newest = "newest"
        static let oldest = "oldest"
    }
    
    // JSON RootKeys
    private let keyMessage = "message"
    private let keyStatus = "status"
    private let keyNumResults = "num_results"
    private let keyResults = "results"
    private let keyResponse = "response"
    private let keyDocs = "docs" //this is an array
    
    // JSON Search Keys
    private let keySearchURL = "web_url"
    private let keySearchDescription = "snippet"
    private let keySearchHeadline = "headline"
    private let keySearchHeadline_main = "main"
    private let keySearchDate = "pub_date"
    private let keySearchImages = "multimedia"
    private let keySearchImageURL = "url"
    
    // JSON TopStory Keys
    private let keyHeadline = "title"
    private let keyDescription = "abstract"
    private let keyURL = "url"
    
    // JSON Media Keys & values
    private let keyMedia = "multimedia"
    private let keyImageURL = "url"
    private let keyImageFormat = "format"
    private struct valueMedia {
        // HxW
        static let smallThumbnail = "Standard Thumbnail" //75x75
        static let largeThumbnail = "thumbLarge" //150x150
        static let mediumWide = "mediumThreebyTwo210" //140x210
        static let normal = "Normal" //127x190
        static let large = "superJumbo" //1297x2048
    }
    private let keyImageHeight = "height"
    
    
    //MARK: SINGLETONE INSTANCE
    static let sharedInstance = NytNewsAPI()
    
    private init() {}
    
    
    //MARK: NEWSAPI FUNCTIONS
    func searchStories(_ count: Int, startingAt: Int, search: String?, updateData: @escaping ([NewsStory]) -> Void) throws {
        
        // https://api.nytimes.com/svc/search/v2/articlesearch.json?q=trump&sort=newest&api-key=6745696533b04c17a90c215f1106f56b
        // check input
        if count < 0 {
            throw NewsAPIError.negativeStart
        }
        if startingAt < 0 {
            throw NewsAPIError.negativeCount
        }
        
        // set up url with param's
        var urlString = searchEndPoint + paramSort + NytNewsAPI.valueSort.newest
        if search != nil {
            urlString +=  "&" + paramSearch + search!
        }
        urlString += "&" + paramAPIKey + apiKey
        let requestURL = try! Network.safeURL(from: urlString)
        
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
                    var stories: [NewsStory] = []
                    
                    // Serialize Json....
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    //print("JSON-Object:",jsonObject)
                    if let message = jsonObject[self.keyMessage] as! String? {
                        print("search request message:",message)
                    }
                    
                    if let status = jsonObject[self.keyStatus] as! String? {
                        if status != "OK" {
                            print("json serilization failed with \(status)")
                        }
                    } else {
                        print("status not found")
                        return
                    }
                    
                    let response = jsonObject[self.keyResponse] as! [String:AnyObject]
                   // print("JSON-RESPONSE:",response)
                    let docs = response[self.keyDocs] as! [[String:AnyObject]]
                    //print("JSON-docs:",docs)
                    for article in docs {
                        //print("JSON-ARTICLE:",article)
                        let url = article[self.keySearchURL] as! String
                        let description = (article[self.keySearchDescription] as! String?) ?? ""
                        let headlineDict = article[self.keySearchHeadline] as! [String:String]
                        let headline = headlineDict[self.keySearchHeadline_main]
                        let media = article[self.keySearchImages] as! [[String:AnyObject]]
                        
                        let newStory = NewsStory(headline: headline!, description: description, url: url)
                        
                        if media.count != 0 {
                            let relativeURL = media[0][self.keySearchImageURL] as? String
                            if relativeURL != nil {
                                newStory.imageURL = self.staticContentEndPoint + relativeURL!
                                newStory.downloadImage()
                            } else {
                                print("image url not found")
                            }
                        } else {
                            print("no images available for: \(url)")
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
        
        
    }
    
    func requestTopStories(_ count: Int, startingAt: Int, updateData: @escaping ([NewsStory]) -> Void) throws {
        print("Forming request for NYT top stories.")
        
        // check param's for errors
        if count < 0 {
            throw NewsAPIError.negativeStart
        }
        if startingAt < 0 {
            throw NewsAPIError.negativeCount
        }
        
        // set up url with param's
        let urlString = topStoriesEndPoint + paramAPIKey + apiKey
        let requestURL = try! Network.safeURL(from: urlString)
    
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
                                let imageFormat = image[self.keyImageFormat] as! String
                                //print("checking image:",imageFormat)
                                if imageFormat == NytNewsAPI.valueMedia.normal {
                                    bestImageURL = image[self.keyImageURL] as! String
                                    //print("using normal image")
                                    break
                                } else {
                                    let imageHeight = image[self.keyImageHeight] as! Int
                                    if imageHeight > bestHeight {
                                        bestHeight = imageHeight
                                        bestImageURL = image[self.keyImageURL] as! String
                                    }
                                }
                            }
                            newStory.imageURL = bestImageURL
                            newStory.downloadImage()
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

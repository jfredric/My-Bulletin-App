//
//  NewsStory.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/16/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation
import UIKit

class NewsStory {
    var headline: String
    var description: String
    var textBody: String?
    var storyURL: String
    var imageURL: String?
    var image: UIImage?
    //var date: ???
    
    init(headline: String, description: String, url: String) {
        self.headline = headline
        self.description = description
        self.storyURL = url
    }
    
    func downloadImage() {
        if imageURL != nil {
            image = Network.downloadImage(urlString: imageURL!)
        }
    }
}

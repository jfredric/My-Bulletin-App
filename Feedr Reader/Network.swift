//
//  File.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/17/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation
import UIKit

enum NetworkErrors: Error {
    case badlyFormatedURL
}

struct Network {
    
    static func downloadImage(urlString: String) -> UIImage? {
        let url = try! safeURL(from: urlString)
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData as Data)
        } catch {
            print("error downloading image file")
        }
        return nil
    }
    
    static func safeURL(from urlString: String) throws -> URL{
        guard let requestedURL = URL(string: urlString) else {
            print("badly formated URL")
            throw NetworkErrors.badlyFormatedURL
        }
        return requestedURL
    }
}


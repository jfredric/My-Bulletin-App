//
//  File.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/17/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

enum NetworkErrors: Error {
    case badlyFormatedURL
    case noInternet
    case timeout
}

class Network {
    
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
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }
}


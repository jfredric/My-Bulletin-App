//
//  Alerts.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/19/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
    
    // Action Sheet Alerts
    static func shareText(text: String, from: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [text as NSString], applicationActivities: nil)
        from.present(activityViewController, animated: true, completion: {})
    }
    static func shareContent(_ content: [Any], from: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: content, applicationActivities: nil)
        from.present(activityViewController, animated: true, completion: {})
    }
    
    // send user a message
    static func messageAlert(title: String, message: String?, from: UIViewController) {
    
        // Create the Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add the button actions - Left to right
        //    OK Button
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
        // Present the Alert
        from.present(alertController, animated: true, completion: nil)
    }
    
    // ask a user to confirm something
    static func confirmAlert(message: String?, from: UIViewController, forYes: ((UIAlertAction) -> Void)? = nil) {
        
        // Create the Alert Controller
        let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add the button actions - Left to right
        //    Cancel Button
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        //    OK Button
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: forYes))
        
        // Present the Alert
        print("Confirming: \(message!)")
        from.present(alertController, animated: true, completion: nil)
    }
}

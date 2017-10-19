//
//  ArticleWebViewController.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/11/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit
import os.lock
import SafariServices

class ArticleWebViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: IB OUTLETS
    @IBOutlet weak var storyContentTextView: UITextView!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyHeadlineLabel: UILabel!
    
    // MARK: PROPERTIES
    var newsStory: NewsStory?
    
    // MARK: VIEW CONTOLLER FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newsStory == nil {
            os_log("Error: newsStory nil on Article View load.", log: OSLog.default, type: .debug)
            // put alert here
            dismiss(animated: true, completion: nil)
        }
        storyContentTextView.text = newsStory?.description
        storyImageView.image = newsStory?.image
        storyHeadlineLabel.text = newsStory?.headline
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: NAVIGATION
    
    // Go back to whichever view opened the article view
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: ACTIONS
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    // open link in safari to article
    @IBAction func websiteButtonTapped(_ sender: Any) {
        let urlString = newsStory!.storyURL
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self as? SFSafariViewControllerDelegate
            
            present(vc, animated: true)
        } else {
            print("Error: \(urlString) is not a URL.")
        }
    }
}

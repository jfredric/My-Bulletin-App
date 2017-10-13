//
//  ArticleWebViewController.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/11/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit
//import WebKit
import SafariServices

class ArticleWebViewController: UIViewController {
    
    //var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let myURL = URL(string: "https://www.bbc.co.uk/news/world-europe-41582469")
        //let myRequest = URLRequest(url: myURL!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ACTIONS
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func websiteButtonTapped(_ sender: Any) {
        let urlString = "https://www.bbc.co.uk/news/world-europe-41582469"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self as? SFSafariViewControllerDelegate
            
            present(vc, animated: true)
        } else {
            print("Error: \(urlString) is not a URL.")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

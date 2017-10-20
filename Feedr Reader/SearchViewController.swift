//
//  SearchViewController.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/9/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: ACTIONS
   
    
    // MARK: SEARCH BAR functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NewsData.sharedInstance.search(forString: searchBar.text ?? "")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: VIEW CONTROLLER FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register prototype cell nibs
        tableView.register(UINib.init(nibName: "RightStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "rightStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LeftStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "leftStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "loadingTableViewCell-ID")
        
        // set up the search controller
        searchBar.delegate = self

        NewsData.sharedInstance.setSearchUpdateCallBack {
            self.tableView.reloadData()
            print("refreshing search tableview")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TABLEVIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NewsData.sharedInstance.isRequestingSearchResults(){
            return NewsData.sharedInstance.searchCount + 1
        } else {
            return  NewsData.sharedInstance.searchCount
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Loading cell
        if NewsData.sharedInstance.isRequestingSearchResults() && indexPath.row == NewsData.sharedInstance.searchCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingTableViewCell-ID", for: indexPath)
            return cell
        }
        
        // story cells
        if NewsData.sharedInstance.searchCount != 0 {
            let story = NewsData.sharedInstance.getSearchStory(at: indexPath.row)
            var reuseID: String
            if indexPath.row % 2 == 0 {
                reuseID = "rightStoryTableViewCell-ID"
            } else {
               reuseID = "leftStoryTableViewCell-ID"
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SmallStoryTableViewCell
            cell.storyHeadlineLabel.text = story.headline
            cell.storyDescriptionLabel.text = story.description
            if story.image == nil {
                cell.storyImageView.image = UIImage(named: "no-image-available")
            } else {
                cell.storyImageView.image = story.image
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingTableViewCell-ID", for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 { // alternatively, make that cell not-selectable.
            self.performSegue(withIdentifier: "showArticleFromSearch-ID", sender: NewsData.sharedInstance.getSearchStory(at: indexPath.row))
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "showArticleFromSearch-ID":
            guard let navViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let articleWebViewController = navViewController.viewControllers.first as? ArticleWebViewController else {
                fatalError("Unexpected view: \(describing: navViewController.viewControllers.first) in \(navViewController)")
            }
            guard let selectedStory = sender as? NewsStory else {
                fatalError("Unexpected sender: \(sender ?? "nil_NewsStory")")
            }
            
            /*guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
             fatalError("The selected cell is not being displayed by the table")
             }*/
            
            articleWebViewController.newsStory = selectedStory
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil_defaultSegue")")
        }
    }

}

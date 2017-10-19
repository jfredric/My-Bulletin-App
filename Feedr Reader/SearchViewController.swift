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
    
    // MARK: TABLEVIEW FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register prototype cell nibs
        tableView.register(UINib.init(nibName: "RightStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "rightStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LeftStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "leftStoryTableViewCell-ID")
        
        // set up the search controller
        searchBar.delegate = self

        NewsData.sharedInstance.setSearchCallBack {
            self.tableView.reloadData()
            print("refreshing search tableview")
        }
        NewsData.sharedInstance.search(forString: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NewsData.sharedInstance.searchCount
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell-ID", for: indexPath) as! SearchTableViewCell
            return cell
        } else {*/ // alternate between left and right image aligned versions of the small story cell
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
            cell.storyImageView.image = story.image
            return cell
        //}
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 { // alternatively, make that cell not-selectable.
            self.performSegue(withIdentifier: "showArticleFromSearch-ID", sender: nil)
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

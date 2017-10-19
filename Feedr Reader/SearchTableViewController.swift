//
//  SearchTableViewController.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/9/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit


class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: ACTIONS
   
    
    // MARK: SEARCH BAR functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NewsData.sharedInstance.search(forString: searchBar.text ?? "")
    }
    
    // MARK: TABLEVIEW FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Register prototype cell nibs
        tableView.register(UINib.init(nibName: "RightStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "rightStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LeftStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "leftStoryTableViewCell-ID")
        
        // set up the search controller
        searchBar.delegate = self
        
        NewsData.sharedInstance.setSearchCallBack {
            self.tableView.reloadData()
            print("refreshing tableview")
        }
        NewsData.sharedInstance.search(forString: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NewsData.sharedInstance.searchCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 { // alternatively, make that cell not-selectable.
            self.performSegue(withIdentifier: "showArticleFromSearch-ID", sender: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FeedTableViewController.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/9/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib.init(nibName: "RightStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "rightStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LeftStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "leftStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "loadingTableViewCell-ID")
        
        NewsData.sharedInstance.setFeedCallBack {
            self.tableView.reloadData()
            print("refreshing tableview")
        }
        NewsData.sharedInstance.requestTopStories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if NewsData.sharedInstance.isRequestingTop(){
            return NewsData.sharedInstance.topCount + 1
        } else {
            return  NewsData.sharedInstance.topCount
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Loading cell
        if NewsData.sharedInstance.isRequestingTop() && indexPath.row == NewsData.sharedInstance.topCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingTableViewCell-ID", for: indexPath)
            return cell
        }
        
        // story cells
        if NewsData.sharedInstance.topCount != 0 {
            let cellStory = NewsData.sharedInstance.getTopStory(at: indexPath.row)
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "topStoryCell-ID", for: indexPath) as! TopStoryTableViewCell
                //cell.headlineLabel.text = "Top Story Now!"
                cell.headlineLabel.text = cellStory.headline
                cell.storyImage.image = cellStory.image
                return cell
            } else { // alternate between left and right image aligned versions of the small story cell
                var reuseID: String
                if indexPath.row % 2 == 0 {
                    reuseID = "rightStoryTableViewCell-ID"
                    
                } else {
                    reuseID = "leftStoryTableViewCell-ID"
                    
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SmallStoryTableViewCell
                cell.storyHeadlineLabel.text = cellStory.headline //"Stories aligned to the left"
                cell.storyDescriptionLabel.text = cellStory.description //"bla bla bla bla"
                cell.storyImageView.image = cellStory.image
                return cell
            }
        } else {
            fatalError("Error in forcellrowat: Should not reach")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showArticleFromFeed-ID", sender: nil)
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

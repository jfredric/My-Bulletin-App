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
        
        tableView.register(UINib.init(nibName: "RightStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "rightStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LeftStoryTableViewCell", bundle: nil), forCellReuseIdentifier: "leftStoryTableViewCell-ID")
        tableView.register(UINib.init(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "loadingTableViewCell-ID")
        
        NewsData.sharedInstance.setFeedUpdateCallBack() {
            self.tableView.reloadData()
            print("refreshing tableview")
        }
        //Notifications.sharedInstance.createNotification(identifier: "testReminder", title: "Reminder", body: "check for new stories", time: 60 ) // create a notifification to go off after ? seconds
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
                if cellStory.image == nil {
                    cell.storyImage.image = UIImage(named: "no-image-available")
                } else {
                    cell.storyImage.image = cellStory.image
                }
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
                //cell.storyDescriptionLabel.text = cellStory.description //"bla bla bla bla"
                if cellStory.image == nil {
                    cell.storyImageView.image = UIImage(named: "no-image-available")
                } else {
                    cell.storyImageView.image = cellStory.image
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingTableViewCell-ID", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showArticleFromFeed-ID", sender: NewsData.sharedInstance.getTopStory(at: indexPath.row))
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "showArticleFromFeed-ID":
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

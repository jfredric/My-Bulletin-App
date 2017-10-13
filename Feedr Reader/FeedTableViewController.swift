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
        return  3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topStoryCell-ID", for: indexPath) as! TopStoryTableViewCell
            cell.headlineLabel.text = "Top Story Now!"
            //cell.storyImage.image =
            return cell
        } else { // alternate between left and right image aligned versions of the small story cell
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "rightStoryTableViewCell-ID", for: indexPath) as! SmallStoryTableViewCell
                cell.storyHeadlineLabel.text = "Stories aligned to the right"
                cell.storyDescriptionLabel.text = "bla bla bla bla"
                //set image here
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftStoryTableViewCell-ID", for: indexPath) as! SmallStoryTableViewCell
                cell.storyHeadlineLabel.text = "Stories aligned to the left"
                cell.storyDescriptionLabel.text = "bla bla bla bla"
                //set image here
                return cell
            }
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

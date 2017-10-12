//
//  SmallSToryTableViewCell.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/12/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit

class SmallSToryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

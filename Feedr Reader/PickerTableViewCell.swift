//
//  PickerTableViewCell.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/14/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

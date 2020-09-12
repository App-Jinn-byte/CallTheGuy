//
//  ReviewTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 24/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewDescriptionTextField: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

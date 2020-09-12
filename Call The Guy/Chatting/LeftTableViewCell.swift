//
//  LeftTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 12/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var userIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

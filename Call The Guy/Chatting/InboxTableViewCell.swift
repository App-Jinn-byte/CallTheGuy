//
//  InboxTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 12/03/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastmessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userIV.layer.cornerRadius = userIV.frame.size.height/2
        userIV.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

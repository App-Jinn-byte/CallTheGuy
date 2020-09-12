//
//  ContractersTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 10/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class ContractersTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    override func awakeFromNib() {
        profileBtn.layer.cornerRadius = profileBtn.frame.size.height/2
        profileBtn.clipsToBounds = true
        
        chatBtn.layer.cornerRadius = chatBtn.frame.size.height/2
        chatBtn.clipsToBounds = true
        
        callBtn.layer.cornerRadius = callBtn.frame.size.height/2
        callBtn.clipsToBounds = true
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
         profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.clipsToBounds = true
    }

}

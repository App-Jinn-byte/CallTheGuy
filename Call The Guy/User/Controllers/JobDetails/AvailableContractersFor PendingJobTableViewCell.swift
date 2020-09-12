//
//  AvailableContractersFor PendingJobTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 07/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol onAcceptJobProtocol: class{
    func onAcceptButtonPressed(cell: AvailableContractersFor_PendingJobTableViewCell)
}
class AvailableContractersFor_PendingJobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contractorName: UILabel!
    @IBOutlet weak var categoriesNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    var delegate: onAcceptJobProtocol?
    var contObject: GetAppliedJobContractors?
    override func awakeFromNib() {
        super.awakeFromNib()
        acceptBtn.layer.cornerRadius = acceptBtn.frame.size.height/2
        acceptBtn.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true
        profileBtn.layer.cornerRadius = profileBtn.frame.size.height/2
        profileBtn.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureCell(){
        guard let data = contObject else{return}
        self.categoriesNameLabel.text = contObject?.CategoryName
        self.contractorName.text = contObject?.UserName
        
        guard let imagePath = (contObject?.Image) else{ return}
        setImage(image: imagePath)
    }
    func setImage(image: String){
        print (image)
        var imagePaths = String(image.dropFirst(3))
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        print(imagePaths)
        if  let url = URL(string: imagePaths)  {
            print(url)
            self.profileImageView.kf.setImage(with: url)
        }
    }
    @IBAction func onAcceptButtonTapped(_ sender: Any) {
        self.delegate?.onAcceptButtonPressed(cell: self)
    }
}


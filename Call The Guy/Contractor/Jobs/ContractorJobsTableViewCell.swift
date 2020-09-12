//
//  ContractorJobsTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 16/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ContractorJobsTableViewCell: UITableViewCell {
    var jobObject: AvailableJobsForContractor?
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var applyJobBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//      applyJobBtn.layer.cornerRadius = applyJobBtn.frame.size.height/2
//        applyJobBtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(){
       guard let data = self.jobObject else { return}
        self.jobTitle.text = data.Title
        self.addressLabel.text = data.LocationName
        self.categoryLabel.text = data.CategoryName
        
        let date = data.PostedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS"
        let date1 = dateFormatter.date(from: date!)
        //        print(blogDate!)
        //        print(date!)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MMM/yyyy"
        let createdDate = dateFormatterPrint.string(from: date1!)
        self.timeLabel.text = createdDate
    }

}

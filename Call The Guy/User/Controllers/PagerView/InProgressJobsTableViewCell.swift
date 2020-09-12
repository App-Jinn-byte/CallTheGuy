//
//  InProgressJobsTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 31/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

protocol jobDetailsDelegate: class{
    func onJobDetailButtonPressed(jobDetail: jobs)
    func onAvailableContractors(jobDetail: jobs)
}
class InProgressJobsTableViewCell: UITableViewCell {

    
    var jobDetailsCell: jobs?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var jobDetailButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: jobDetailsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusButton.layer.cornerRadius = statusButton.frame.size.height/2
        statusButton.clipsToBounds = true
        jobDetailButton.layer.cornerRadius = jobDetailButton.frame.size.height/2
        jobDetailButton.clipsToBounds = true
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(){
         guard let data = self.jobDetailsCell else { return }
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
        self.titleLabel.text = data.Title
        self.dateLabel.text = createdDate
        self.descLabel.text = data.Description
        if let id = data.Fee {
            self.priceLabel.text = String(id)
        }
        else{
            self.priceLabel.text = ""
        }
    }
    @IBAction func jobDetailbtn(_ sender: Any) {
        guard let data1 = self.jobDetailsCell else { return }
        self.delegate?.onJobDetailButtonPressed(jobDetail: data1)
    }
}

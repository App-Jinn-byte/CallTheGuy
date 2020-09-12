//
//  AppointmentsTableViewCell.swift
//  Call The Guy
//
//  Created by JanAhmad on 05/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
    
class AppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var contNameLabel: UILabel!

    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var appointmenObject: appointmentsList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(){
        guard let data = appointmenObject else{return}
        self.titleLabel.text = data.Title
        
        self.categoriesLabel.text = data.Categories
        self.contNameLabel.text = data.Name
        var date = data.CreatedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS"
        let date1 = dateFormatter.date(from: date!)
        //        print(blogDate!)
        //        print(date!)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MMM/yyyy"
        
        var createdDate = dateFormatterPrint.string(from: date1!)
        self.dateLabel.text = createdDate
        dateFormatterPrint.dateFormat = "h:mm a"
        var createdTime = dateFormatterPrint.string(from: date1!)
        timeLabel.text = createdTime
        guard let imagePath = data.URL else{ return}
        setImage(image: imagePath)
    }
    func setImage(image: String){
        print (image)
        var imagePaths = String(image.dropFirst(3))
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        print(imagePaths)
        let urlString = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print(urlString!)
        let url = URL(string: urlString!)
            print(url)
            self.userImageView.kf.setImage(with: url)
    }

}

//
//  DisputeDetailViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 03/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class DisputeDetailViewController: UIViewController {
    @IBOutlet weak var appointmentIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descrTextView: UITextView!
    var disputeDetail: String?
    var disputeList: list?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = " "
        
        if let value = disputeList?.JobId {
            appointmentIdLabel.text = String(value)
        }
        else{
            appointmentIdLabel.text = "";
        }
        descrTextView.text = disputeList?.Description
        statusLabel.text = disputeDetail
        guard let imagePath = (disputeList?.Image) else{ return}
        setImage(image: imagePath)
    }
    func setImage(image: String){
        print (image)
        var imagePaths = String(image.dropFirst(3))
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        print(imagePaths)
        if  let url = URL(string: imagePaths)  {
            print(url)
            self.imageView.kf.setImage(with: url)
        }
    }
}

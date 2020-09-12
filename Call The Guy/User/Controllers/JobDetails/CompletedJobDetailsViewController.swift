//
//  CompletedJobDetailsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 01/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class CompletedJobDetailsViewController: UIViewController {
    
    var jobDetail: jobs?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var jobActionBtn: UIButton!
    @IBOutlet weak var createDisputeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setFields()
        if jobDetail?.JobStatusId == 4 || jobDetail?.JobStatusId == 1 || jobDetail?.JobStatusId == 5{
            self.jobActionBtn.isHidden = true
            self.createDisputeBtn.isHidden = true
        }
        else if (Constants.userTypeId == 4){
            self.jobActionBtn.isHidden = true
            self.createDisputeBtn.isHidden = true
        }
    
        jobActionBtn.layer.cornerRadius = jobActionBtn.frame.size.height/2
        jobActionBtn.clipsToBounds = true
        createDisputeBtn.layer.cornerRadius = createDisputeBtn.frame.size.height/2
        createDisputeBtn.clipsToBounds = true
        
       // let backBarButton = UIBarButtonItem.init(image: UIImage.init(named: "backBtn"), style: .done, target: self, action: #selector(backButtonTapped(sender:)))
        let backBarButton = UIBarButtonItem(image: UIImage.init(named: "backBtn"), style: .done, target: self, action: #selector(backButtonTapped))
        //self.navigationItem.rightBarButtonItem  = backBarButton
        self.navigationItem.setLeftBarButton(backBarButton, animated: true)
        self.title = "Job Details"
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func jobActionButton(_ sender: Any) {
        let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController
        popUpVc.JobDetail = jobDetail
        self.addChild(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParent: self)
    }
    
    @IBAction func createDisputeAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateDispute") as! CreateDisputeViewController
            //viewController.jobDetail = jobDetail
        vc.jobId = self.jobDetail?.JobId
        navigationController!.pushViewController(vc, animated: true)
    }
    
    func setFields(){
        titleLabel.text = jobDetail?.Title
        categoryLabel.text = jobDetail?.CategoryName
        descrLabel.text = jobDetail?.Description
        locationLabel.text = jobDetail?.LocationName
        assignedToLabel.text = jobDetail?.AssignedTo
        if let price = jobDetail?.Fee {
            priceLabel.text = String(price)
        }
        else{
            priceLabel.text = ""
        }
        contactNoLabel.text = jobDetail?.Mobile
        guard let imagePath = (jobDetail?.JobImage) else{ return}
        setImage(image: imagePath)
    }
    func setImage(image: String){
        print (image)
        var imagePaths = String(image.dropFirst(3))
        imagePaths = "https://www.calltheguy.co.za/"+imagePaths
        print(imagePaths)
        if  let url = URL(string: imagePaths)  {
            print(url)
            self.jobImageView.kf.setImage(with: url)
        }
    }
}

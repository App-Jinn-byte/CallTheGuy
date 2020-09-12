//
//  ApplyJobDetailViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 16/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ApplyJobDetailViewController: UIViewController {
    var jobObject: AvailableJobsForContractor?
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var jobActionBtn: UIButton!
    @IBOutlet weak var applyJobBtn: UIButton!
    var jobId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobActionBtn.layer.cornerRadius = jobActionBtn.frame.size.height/2
        jobActionBtn.clipsToBounds = true
        
        //print(jobObject)
        let backBarButton = UIBarButtonItem.init(image: UIImage.init(named: "backBtn"), style: .done, target: self, action: #selector(backButtonTapped(sender:)))
        
        self.navigationItem.setLeftBarButton(backBarButton, animated: true)
        self.title = "Job Details"
        setFields()
    }
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyJob(_ sender: Any) {
     Constants.Alert1(title: "APPLY JOB", message: "Are you sure to want to apply on this job", controller: self, action: handlerSuccess())
    }
    func setFields(){
        categoryLabel.text = jobObject?.CategoryName
        titleLabel.text = jobObject?.Title
        descrLabel.text = jobObject?.Description
        locationLabel.text = jobObject?.LocationName
        assignedToLabel.text = jobObject?.PostedByName
        //self.jobId = jobObject?.JobId
        if let fee = jobObject?.Fee {
            self.priceLabel.text = String(fee)
        }
        else{
            self.priceLabel.text = ""
        }
        contactNoLabel.text = jobObject?.Mobile
        guard let imagePath = (jobObject?.JobImage) else{ return}
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
    
    func handlerSuccess() -> (UIAlertAction) -> (){
        
        return { action in
            let jobId = self.jobId
            let contId = Constants.userId
            let param:[String:Any] = ["JobId":jobId!,"ContractorId":contId]
            
            
            
            if Reachability.isConnectedToNetwork(){
                
                APIRequest.ApplyJob(parameters: param, completion: self.APIRequestCompletedForApplyJob)
            }
            else {
                print("Internet connection not available")
                
                Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
            }
        }
    }
    fileprivate func APIRequestCompletedForApplyJob(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let applyJob = try decoder.decode(CloaseAppointmentModelResponse.self, from: data)
            
                print(applyJob)
                applyJobBtn?.setTitle("Applied", for:.disabled)
                applyJobBtn?.setTitle("Applied", for:.normal)
                //a.isUserInteractionEnabled = false
                self.navigationController?.popViewController(animated: true)
            }
            catch {
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
        
    }
}

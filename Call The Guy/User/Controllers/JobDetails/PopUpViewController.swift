//
//  PopUpViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 02/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    var JobDetail: jobs?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dontWantJObCheckBox: UIButton!
    @IBOutlet weak var jobCompletedCheckBox: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var jobCloseId: Int = 4
    var jobId: Int?
    var contractorId: Int?
    var userId = Constants.userId
    var jobStatus: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        jobId = JobDetail?.JobId
        contractorId = JobDetail?.AssignedToId
        jobStatus = JobDetail?.JobStatusId
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.clipsToBounds = true
    }

    @IBAction func JobCompletecheckboxBtn(_ sender: Any) {
        if jobCompletedCheckBox.backgroundImage(for: .normal) == UIImage.init(named: "fillCheckBox"){
            // dontWantJObCheckBox.setBackgroundImage(UIImage.init(named: "emptyCheckBox"), for: .normal)
            jobCloseId = 4
            print()
        }
        else{
            jobCompletedCheckBox.setBackgroundImage(UIImage.init(named: "fillCheckBox"), for: .normal)
             dontWantJObCheckBox.setBackgroundImage(UIImage.init(named: "emptyCheckbox"), for: .normal)
            jobCloseId = 4
        }
    }
    @IBAction func dontWantJobCheckBoxButton(_ sender: Any) {
        if dontWantJObCheckBox.backgroundImage(for: .normal) == UIImage.init(named: "emptyCheckbox"){
            dontWantJObCheckBox.setBackgroundImage(UIImage.init(named: "fillCheckBox"), for: .normal)
            jobCompletedCheckBox.setBackgroundImage(UIImage.init(named: "emptyCheckbox"), for: .normal)
            jobCloseId = 5
        }
        else{
           // jobCompletedCheckBox.setBackgroundImage(UIImage.init(named: "emptyCheckbox"), for: .normal)
            jobCloseId = 5
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func submitBtn(_ sender: Any) {
        print(jobCloseId)
        
         let param:[String:Any] = ["JobId":jobId!,"ContractorId":contractorId!,"userId": userId,"JobStatusId":jobCloseId]
     
        
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            
            APIRequest.CloseJob(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let closeJob = try decoder.decode(CloseJobModelResponse.self, from: data)
                print(closeJob)
                activityIndicator.stopAnimating()
                
                Constants.Alert(title: "Success", message: "Job Closed Successfully", controller: self, action: handlerSuccessAlert())
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Error", message: Constants.loginErrorMessage, controller: self)
        }
        
    }
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            // self.performSegue(withIdentifier: "Reset", sender: nil)
            //self.navigationController?.popViewController(animated: true)
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Rating") as! RatingViewController
            vc.jobId = self.jobId
            vc.contId = self.contractorId
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}

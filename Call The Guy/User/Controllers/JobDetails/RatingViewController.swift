//
//  RatingViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 31/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Cosmos
class RatingViewController: UIViewController {
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var descriptionTextfield: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    var test = ""
    var jobId:Int?
    var contId:Int?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = submitBtn.frame.height/2
        submitBtn.clipsToBounds = true
        descriptionTextfield.delegate = self
        descriptionTextfield.layer.cornerRadius = descriptionTextfield.frame.size.height/6
        descriptionTextfield.clipsToBounds = true
        descriptionTextfield.textContainerInset = UIEdgeInsets(top: 10, left: 40, bottom: 0, right: 0)
        descriptionTextfield.text = "Description"
        descriptionTextfield.textColor = UIColor.init(named: "placeholder")
        let backBarButton = UIBarButtonItem(image: UIImage.init(named: "backBtn"), style: .done, target: self, action: #selector(backButtonTapped1))
        //self.navigationItem.rightBarButtonItem  = backBarButton
        self.navigationItem.setLeftBarButton(backBarButton, animated: true)
        
       // self.navigationItem.setLeftBarButton(backBarButton, animated: true)
        self.title = "Ratings"
    }
    @objc func backButtonTapped1(sender: UIBarButtonItem) {
        //self.navigationController?.popViewController(animated: true)
        print("action button tapped")
        //for controller in self.navigationController!.viewControllers as Array {
          //  if controller.isKind(of: CompletedJobDetailsViewController.self) {
            //    self.navigationController!.popToViewController(controller, animated: true)
             //   break
         //   }
        //}
       // self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        let jobId = self.jobId
        let score = ratingBar.rating
        let description = descriptionTextfield.text
        let ratedBy = Constants.userId
        let isContracter:Bool
        if Constants.userTypeId == 3{
            isContracter = false
        }
        else {
            isContracter = true
        }
        let param:[String:Any] = ["JobId":jobId!,"CandidateId":contId!,"IsContractor": isContracter,"RatedBy":ratedBy,"Remarks":description , "Score": score]
        
            
            
            if Reachability.isConnectedToNetwork(){
                activityIndicator.startAnimating()
                
                APIRequest.Rating(parameters: param, completion: APIRequestCompleted)
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
                
                Constants.Alert(title: "Success", message: " Successfully rated", controller: self, action: handlerSuccessAlert())
                
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
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
extension RatingViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextfield.isFirstResponder && descriptionTextfield.text == "Description" {
            descriptionTextfield.text = ""
            descriptionTextfield.textColor = UIColor.white
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            if descriptionTextfield.text == "" {
                descriptionTextfield.text = "Description"
                descriptionTextfield.textColor = UIColor.init(named: "placeholder")
            }
        }
    }
}

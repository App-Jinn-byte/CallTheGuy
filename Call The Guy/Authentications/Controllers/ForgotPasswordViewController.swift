//
//    ForgotPasswordViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 14/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    public var userTypeId:Int?
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        let email = emailTextField.text
        let userType_Id = userTypeId
        
        if(email == "" ){
            Constants.Alert(title: "ERROR", message: "Email required...", controller: self)
            return
        }
        if !(email!.isValidEmail ){
            Constants.Alert(title: "ERROR", message: "Please Enter Valid Email...", controller: self)
            return
        }
        let param:[String:Any] = ["Email":email!,"UserTypeId": userType_Id!]
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            APIRequest.ForgotPassword(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgLight1 =  UIColor(red: 70.0/255.0, green: 101.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
        let bgDark1 = UIColor(red: 33.0/255.0, green: 53.0/255.0, blue: 79.0/255.0, alpha: 1.0).cgColor
    
        let gradient = CAGradientLayer()
        gradient.colors = [bgLight1, bgDark1]
        // gradient.locations = [0.0,1.0]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.frame
        view.layer.addSublayer(gradient)
        view.layer.insertSublayer(gradient, at: 0)
        
        emailTextField.layer.cornerRadius = emailTextField.frame.size.height/2
        emailTextField.clipsToBounds = true
        
        emailTextField.setLeftPaddingPoints(40)
    
        submitButton.layer.cornerRadius = submitButton.frame.size.height/2
        submitButton.clipsToBounds = true
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = UIColor.white.cgColor
        
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
       
        self.hideKeyboardWhenTappedAround()

    }
 
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            

            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let forgotPassword = try decoder.decode(ForgotPasswordModelResponse.self, from: data)
                
               // print(forgotPassword.CNIC)
               Constants.userEmail = forgotPassword.Email
                Constants.userId = forgotPassword.UserId
                   Constants.Alert1(title: "Reset Password", message: "Email exist please Update your password", controller: self, action: handlerSuccessAlert())
                activityIndicator.stopAnimating()
            } catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            self.performSegue(withIdentifier: "Reset", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
            let vc = segue.destination as? ResetPasswordViewController
        vc?.email = Constants.userEmail
        vc?.userId = Constants.userId
    }
}

//
//  ResetPasswordViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 14/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import Alamofire

class ResetPasswordViewController: UIViewController {
    
    public var userTypeId = Constants.userTypeId
    public var userId:Int?
    public var email:String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    

    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
                  let email1 = email
                  let userId1 = userId
                  let password1 = passwordTextField.text
                  let password2 = retypePasswordTextField.text
                  let userType_Id = userTypeId
        
        if(password1 == "" || password2 == ""){
            Constants.Alert(title: "ERROR", message: "Both fields are required...", controller: self)
            return
        }
        else if(password1 != password2){
            Constants.Alert(title: "ERROR", message: "Password is not matching...", controller: self)
            return
        }
        else if(password1!.count < 3  ){
            Constants.Alert(title: "ERROR", message: "Password is too short...", controller: self)
            return
        }
        
        
        let param:[String:Any] = ["Email":email1!,"Password": password1! , "UserTypeId": userType_Id , "UserId": userId1!]
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            APIRequest.ResetPassword(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
@IBAction func backButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(userId)
        print(email)
        print(Constants.userTypeId)
    
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
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.height/2
        passwordTextField.clipsToBounds = true
        
        passwordTextField.setLeftPaddingPoints(40)
        
        retypePasswordTextField.layer.cornerRadius = retypePasswordTextField.frame.size.height/2
        retypePasswordTextField.clipsToBounds = true
        
        retypePasswordTextField.setLeftPaddingPoints(40)
        
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

                let resetPassword = try decoder.decode(ResetPasswordModelResponse.self, from: data)

                Constants.Alert1(title: "Success", message: "\(resetPassword.Message)", controller: self, action: handler())
                activityIndicator.stopAnimating()

            } catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage ?? "", controller: self)
            }

        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    func handler() -> (UIAlertAction) -> () {
        return { action in
            self.performSegue(withIdentifier: "User", sender: nil)
        }
    }
}

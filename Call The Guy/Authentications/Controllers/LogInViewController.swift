//
//  LogInViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 13/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    public var userTypeId1: Int?
    public var deviceId: String?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let defaults = UserDefaults.standard
    
    @IBAction func backButton(_ sender: Any) {
        //performSegue(withIdentifier: "User", sender: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Register", sender: self)
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        performSegue(withIdentifier: "Forgot", sender: nil)
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonAction(_ sender: Any) {
        print(Constants.userTypeId)
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if(email == "" || password == ""){
            Constants.Alert(title: "LogIn Error", message: "Both fields are required", controller: self)
            return
        }
            
        else if password!.count < 3 {
            
            Constants.Alert(title: "Login Error!", message: "Incorrect email or password", controller: self)
            
            return
        }
        else if email!.isEmpty || !(email!.isValidEmail) {
            Constants.Alert(title: "Invalid Email", message: "Please Enter Valid Email", controller:  self)
            
        }
        
        deviceId = UIDevice.current.identifierForVendor!.uuidString
        print(deviceId!)
        
        let param:[String:Any] = ["Email":email!,"Password":password!,"UserTypeId": Constants.userTypeId,"DeviceId":deviceId!]
        
        activityIndicator.startAnimating()
        if Reachability.isConnectedToNetwork(){
            
            APIRequest.Login(parameters: param, completion: APIRequestCompleted)
        }
        else {
            activityIndicator.stopAnimating()
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
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.height/2
        passwordTextField.clipsToBounds = true
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.clipsToBounds = true
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        emailTextField.setLeftPaddingPoints(40)
        passwordTextField.setLeftPaddingPoints(40)
        
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        loginButton.setAttributedTitle(nil, for: .normal)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Reachability.isConnectedToNetwork(){
            if segue.identifier == "Register"{
                let vc = segue.destination as! RegisterationViewController
                vc.userTypeId = Constants.userTypeId
                vc.deviceId   = deviceId
            }
            else if (segue.identifier == "Forgot"){
                let vc = segue.destination as! ForgotPasswordViewController
                vc.userTypeId = Constants.userTypeId
            }
            else{
                print("back to user screen")
            }
        }
        else {
            Constants.Alert(title: "No Internet Connection", message: "Please connect to an Internet", controller: self)
            return
        }
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let loginResponse = try decoder.decode(LoginModelResponse.self, from: data)
                print(loginResponse.CNIC)
                print(loginResponse.Email)
                
                self.defaults.set(loginResponse.Email, forKey: "email")
                self.defaults.set(loginResponse.Password, forKey: "password")
                activityIndicator.stopAnimating()
                Constants.userId = loginResponse.UserId
                Constants.userName = loginResponse.UserName
                
                Constants.userProfile = loginResponse.ImagePath ?? "Hello"
                UserDefaults.standard.set(true, forKey: "LoggedIn")
                UserDefaults.standard.set(loginResponse.UserId, forKey: "UserId")
                UserDefaults.standard.set(loginResponse.UserName, forKey: "UserName")
                UserDefaults.standard.set(loginResponse.UserTypeId, forKey: "UserTypeId")
                //Constants.Alert(title: "Success", message: "\(loginResponse.UserName)Successfully LoggedIn", controller: self)
                
                if (loginResponse.UserTypeId == 3){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
                self.present(controller, animated: true, completion: nil)
                }
                else{
                    let storyboard = UIStoryboard(name: "Contracter", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBar2")
                    self.present(controller, animated: true, completion: nil)
                }
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    
}


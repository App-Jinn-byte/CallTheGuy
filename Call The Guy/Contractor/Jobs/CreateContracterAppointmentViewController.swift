//
//  CreateContracterAppointmentViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 16/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class CreateContracterAppointmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

   
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var contractorsTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    var datePicker: UIDatePicker?
    var timePicker: UIDatePicker?
    var usersList = [GetAllContractorsModelResponse]()
    var withId: Int?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // dateTextField.delegate = self
        dateTextField.tintColor = .clear
        timeTextField.tintColor = .clear
        contractorsTextField.tintColor = .clear
        setLayout()
        setPickers()
        APIRequest.FetchAllUsers(completion: APIRequestCompletedForContractors)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        let type = typeTextField.text
        let title = typeTextField.text
        let date = dateTextField.text
        let contId = withId
        let user = Constants.userId
        let dateRversed = date?.reversed()
        
        if(type == "" || title == "" || date == "" || contractorsTextField.text == ""){
            Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
            return
        }
        
        let param:[String:Any] = ["Title":title!,"Type":type!,"WithId": contId!,"CreatedBy":user, "CreatedDate":dateRversed!]
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            
            APIRequest.CreateAppointment(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    fileprivate func APIRequestCompletedForContractors(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let users = try decoder.decode([GetAllContractorsModelResponse].self, from: data)
                print(users.count)
                usersList = users
                setPickers()
            }
            catch {
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "Catch", controller: self)
            }
        }
        else{
            Constants.Alert(title: "Error", message: "Not Valid Response", controller: self)
        }
        
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let appointment = try decoder.decode(CreateAppointmentModelResponse.self, from: data)
                print(appointment)
                
                activityIndicator.stopAnimating()
                
                Constants.Alert1(title: "Success", message: "Appointment created Successfully", controller: self, action: handlerSuccessAlert())
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "Catch", controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
        
    }
    
    func setPickers(){
        timePicker = UIDatePicker()
        datePicker = UIDatePicker()
        let contractorsList = UIPickerView()
        contractorsList.delegate = self
        
        timeTextField.inputView = timePicker
        dateTextField.inputView = datePicker
        contractorsTextField.inputView = contractorsList
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(named: "bgDark")
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        //selectCategoryTextField.inputView = catPicker
        timeTextField.inputAccessoryView = toolBar
        dateTextField.inputAccessoryView = toolBar
        contractorsTextField.inputAccessoryView = toolBar
        
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(self.timeChange(dateTime:)), for: .valueChanged)
        
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChange(dateDate:)), for: .valueChanged)
        
        
        
    }
    @objc func timeChange(dateTime: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        var time = dateTime.date
        timeTextField.text = dateFormatter.string(from: time)
        
    }
    
    @objc func dateChange(dateDate: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        var time = dateDate.date
        dateTextField.text = dateFormatter.string(from: time)
    }
    
    @objc func donePicker() {
        timeTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        contractorsTextField.resignFirstResponder()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(usersList.count)
        return usersList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usersList[row].UserName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        contractorsTextField.text = usersList[row].UserName
        withId = usersList[row].UserId
    }
    
    func setLayout(){
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
        
        titleTextField.layer.cornerRadius = titleTextField.frame.size.height/2
        titleTextField.clipsToBounds = true
        
        typeTextField.layer.cornerRadius = typeTextField.frame.size.height/2
        typeTextField.clipsToBounds = true
        
        timeTextField.layer.cornerRadius = timeTextField.frame.size.height/2
        timeTextField.clipsToBounds = true
        
        dateTextField.layer.cornerRadius = dateTextField.frame.size.height/2
        dateTextField.clipsToBounds = true
        
        contractorsTextField.layer.cornerRadius = contractorsTextField.frame.size.height/2
        contractorsTextField.clipsToBounds = true
        
        submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2
        submitBtn.clipsToBounds = true
        
        descriptionTextField.text = "Description"
        descriptionTextField.textColor = UIColor.init(named: "placeholder")
        
        descriptionTextField.layer.cornerRadius = descriptionTextField.frame.size.height/6
        descriptionTextField.clipsToBounds = true
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 10, left: 40, bottom: 0, right: 0)
        
        submitBtn.layer.borderWidth = 1.0
        submitBtn.layer.borderColor = UIColor.white.cgColor
        
        typeTextField.setLeftPaddingPoints(40)
        timeTextField.setLeftPaddingPoints(40)
        titleTextField.setLeftPaddingPoints(40)
        dateTextField.setLeftPaddingPoints(40)
        contractorsTextField.setLeftPaddingPoints(40)
        self.hideKeyboardWhenTappedAround()
    }
    
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//
//  CreateDisputeViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 02/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Photos

class CreateDisputeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var imageExtension: String?
    private var byteArray: String?
    private var isImageAttached : Bool = false
    @IBOutlet weak var appointmentIdTextField: UITextField!
    @IBOutlet weak var contractorIdTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var disputeTitleTextField: UITextField!
    @IBOutlet weak var attachImageBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var jobId: Int?
    var myPickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        let backBarButton = UIBarButtonItem.init(image: UIImage.init(named: "backBtn"), style: .done, target: self, action: #selector(backButtonTapped(sender:)))
        
        self.navigationItem.setLeftBarButton(backBarButton, animated: true)
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "bgDark")
        self.navigationItem.title = "Create Dispute"
        //self.navigationController?.navigationBar.tintColor = .white
        setLayout()
        // Do any additional setup after loading the view.
    }
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func attachImageBtn(_ sender: Any) {

        myPickerController.allowsEditing = true
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
        
    }
    
    // Mark:- Did  Finish Func for image picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let image0 = imageView.image
        //print(image0)
        //let data = image0?.pngData()
        //print(data)
        let data1 = image0?.jpegData(compressionQuality: 0.7)
        let uiImage = UIImage(data: data1! as Data)
        var typeArray = getImageString(imageData: data1! as NSData)
        print(typeArray)
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let  myStringArr = imgName.components(separatedBy: ".")
            imageExtension = myStringArr[1]
            print(imageExtension)
        }
        
        isImageAttached = true
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getImageString(imageData:NSData) -> String
    {
        let count1 = imageData.length / sizeof(UInt16.self)
        var bytes1 = [UInt16](repeating: 0, count: count1)

        imageData.getBytes(&bytes1, length:count1 * sizeof(UInt16.self))
        let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
        byteArray = imageStr
        
        return imageStr
    }
    
    func sizeof<T:FixedWidthInteger>(_ intType:T.Type) -> Int {
        return intType.bitWidth/UInt8.bitWidth
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
           // present(myPickerController, animated: true, completion: nil)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    //self.present(self.myPickerController, animated: true, completion: nil)
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
            Constants.Alert(title: "Permission Denied", message: "Please grant permission from settings to access photo library", controller: self)
        }
    }
    
    @IBAction func submitDispute(_ sender: Any) {
        let appointment = appointmentIdTextField.text
        let contractor = contractorIdTextField.text
        let title = disputeTitleTextField.text!
        let description = descriptionTextView.text
        let JobId = self.jobId!
        
        if(appointment == "" || contractor == "" || title == "" || title == ""){
            Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
            return
        }
        else if (isImageAttached == false){
            
            Constants.Alert(title: "Attach File", message: "Please! attach image..", controller: self)
            return
        }
        
        let param:[String:Any] = ["JobId":JobId,"Title":title,"Description": description!,"CreatedBy":Constants.userId]
        
        
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            
            APIRequest.CreateDispute(parameters: param, completion: APIRequestCompleted)
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
                
                let dispute = try decoder.decode(CreateDisputeModelResponse.self, from: data)
                print(dispute.Id)
                
              
                
                let param:[String:Any] = ["id":dispute.Id, "Extension":".\(imageExtension!)","Image":"\(byteArray!)"]
                
                
                APIRequest.SaveDisputeImage(parameters: param, completion: APIRequestCompletedForImage)
                activityIndicator.stopAnimating()
                
                Constants.Alert1(title: "Success", message: "Dispute created Successfully", controller: self, action: handlerSuccessAlert())
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
        
    }
    
    
    fileprivate func APIRequestCompletedForImage(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let imageResponse = try decoder.decode(DisputeImageModelResponse.self, from: data)
                print(imageResponse.Id)
                print(imageResponse.Path)
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
        
        appointmentIdTextField.layer.cornerRadius = appointmentIdTextField.frame.size.height/2
        appointmentIdTextField.clipsToBounds = true
        
        contractorIdTextField.layer.cornerRadius = contractorIdTextField.frame.size.height/2
        contractorIdTextField.clipsToBounds = true
        
        disputeTitleTextField.layer.cornerRadius = disputeTitleTextField.frame.size.height/2
        disputeTitleTextField.clipsToBounds = true
        
        attachImageBtn.layer.cornerRadius = attachImageBtn.frame.size.height/2
        attachImageBtn.clipsToBounds = true
        
        submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2
        submitBtn.clipsToBounds = true
        
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        self.imageView.clipsToBounds = true;
        
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.init(named: "placeholder")
        
        descriptionTextView.layer.cornerRadius = descriptionTextView.frame.size.height/6
        descriptionTextView.clipsToBounds = true
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 40, bottom: 0, right: 0)
        
        submitBtn.layer.borderWidth = 1.0
        submitBtn.layer.borderColor = UIColor.white.cgColor
        
        appointmentIdTextField.setLeftPaddingPoints(40)
        contractorIdTextField.setLeftPaddingPoints(40)
        disputeTitleTextField.setLeftPaddingPoints(40)
        // descriptionTextField.setLeftPaddingPoints(40)
        // self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.hideKeyboardWhenTappedAround()
    }
    
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            // self.performSegue(withIdentifier: "Reset", sender: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreateDisputeViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.isFirstResponder && descriptionTextView.text == "Description" {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text == "" {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = UIColor.init(named: "placeholder")
        }
    }
}

//
//  PostNewJobViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 23/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Photos

class PostNewJobViewController: UIViewController,UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    //var cat = CategoriesViewController().categoryList
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var selectCategoryTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var sampleImageView: UIImageView!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    var catPicker: UIPickerView?
    var myPickerController = UIImagePickerController()
    let locationManager = CLLocationManager()
    var lat = 0.0
    var lng = 0.0
    var catId: Int?
    private var imageExtension: String?
    private var byteArray: String?
    private var isImageAttached : Bool = false
    var newArrayList = [CategoriesListModelResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        setPickerView()
        setLayout()
        
        
        print(Constants.catList)
        descriptionTextField.delegate = self
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 13, left: 40, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
        print(newArrayList)
        //getList(categories: ca)
    }
    @IBAction func getLocationBtn(_ sender: Any) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var pvc = storyboard.instantiateViewController(withIdentifier: "GetLocation") as! GetLocationViewController
        pvc.delegate = self
        pvc.view.frame.size.height = 300
        self.present(pvc, animated: true, completion: nil)
    }
    
    
    @IBAction func attachImageBtn(_ sender: Any) {
        
        myPickerController.allowsEditing = true
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
        
    }
    
    // Mark:- Did  Finish Func for image picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        sampleImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let image0 = sampleImageView.image
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
        
        jobTitleTextField.layer.cornerRadius = jobTitleTextField.frame.size.height/2
        jobTitleTextField.clipsToBounds = true
        
        selectCategoryTextField.layer.cornerRadius = selectCategoryTextField.frame.size.height/2
        selectCategoryTextField.clipsToBounds = true
        
        addressTextField.layer.cornerRadius = addressTextField.frame.size.height/2
        addressTextField.clipsToBounds = true
        
        maxPriceTextField.layer.cornerRadius = maxPriceTextField.frame.size.height/2
        maxPriceTextField.clipsToBounds = true
        
        attachBtn.layer.cornerRadius = attachBtn.frame.size.height/2
        attachBtn.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = registerBtn.frame.size.height/2
        registerBtn.clipsToBounds = true
        
        self.sampleImageView.layer.cornerRadius = self.sampleImageView.frame.size.width / 2;
        self.sampleImageView.clipsToBounds = true;
        
        descriptionTextField.text = "Description.."
        descriptionTextField.textColor = UIColor.init(named: "placeholder")
        
        registerBtn.layer.borderWidth = 1.0
        registerBtn.layer.borderColor = UIColor.white.cgColor
        
        jobTitleTextField.setLeftPaddingPoints(40)
        maxPriceTextField.setLeftPaddingPoints(40)
        addressTextField.setLeftPaddingPoints(40)
        //        descriptionTextField.setLeftPaddingPoints(40)
        selectCategoryTextField.setLeftPaddingPoints(40)
        
        
        // self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if descriptionTextField .isFirstResponder {
            descriptionTextField.text = ""
            descriptionTextField.textColor = UIColor.white
        }
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
    func sizeof<T:FixedWidthInteger>(_ intType:T.Type) -> Int {
        return intType.bitWidth/UInt8.bitWidth
    }
    
    func setPickerView(){
        let catPicker = UIPickerView()
        catPicker.delegate = self
        //catPicker.backgroundColor = UIColor.init(n)
        catPicker.setValue(UIColor.black, forKeyPath: "textColor")
        //catPicker.showsSelectionIndicator = true
        selectCategoryTextField.inputView = catPicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(named: "bgDark")
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //selectCategoryTextField.inputView = catPicker
        selectCategoryTextField.inputAccessoryView = toolBar
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.catList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.catList[row].Name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCategoryTextField.text = Constants.catList[row].Name
        catId = Constants.catList[row].CategoryId
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = Constants.catList[row].Name
        return NSAttributedString(string: string!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "bgDark")])
    }
    @objc func donePicker() {
        selectCategoryTextField.resignFirstResponder()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        lat = locValue.latitude
//        lng = locValue.longitude
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        print(lat)
//        print(lng)
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(locations[0]) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            guard let placemark = placemarks as? [CLPlacemark] else {return}
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//                print(placemark.location!)
//                print(placemark.areasOfInterest)
//                print(placemark.name!)
//                print(placemark.description)
//                print(placemark.postalCode)
//                print(placemark.thoroughfare)
//
//
//             //   self.addressTextField.text = "\(placemark.name!),\(placemark.postalCode ?? ""),\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
//             //   print(self.addressTextField)
//            }
//        }
//
//    }
    
    @IBAction func submitDispute(_ sender: Any) {
        let locationName = addressTextField.text
        let locationCord = "\(lat)_\(lng)"
        let jobTitle = jobTitleTextField.text
        let categoryId = catId
        let fee = maxPriceTextField.text
        let postedBy = Constants.userId
        let description = descriptionTextField.text
        
        if(locationName == "" || locationCord == "" || jobTitle == "" || selectCategoryTextField.text == "" || fee == "" || description == ""){
            Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
            return
        }
        else if (isImageAttached == false){
            
            Constants.Alert(title: "Attach File", message: "Please! attach image..", controller: self)
            return
        }
        
        let param:[String:Any] = ["LocationName":locationName!,"Location":locationCord,"CategoryId": categoryId!,"Fee":fee!,"PostedBy":postedBy,"FeedBack":description! ,"Title":jobTitle!]
        
        
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            
            APIRequest.CreateJob(parameters: param, completion: APIRequestCompleted)
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
                
                let job = try decoder.decode(CreateJobModelresponse.self, from: data)
                print(job)
                
                let param:[String:Any] = ["id":job.Id, "Extension":".\(imageExtension!)","Image":"\(byteArray!)"]
                
                APIRequest.SaveJobImage(parameters: param, completion: APIRequestCompletedForImage)
                activityIndicator.stopAnimating()
                
            Constants.Alert(title: "Success", message: "Job created Successfully", controller: self, action: handlerSuccessAlert())
                
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
                
                let imageResponse = try decoder.decode(JobImageModelResponse.self, from: data)
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
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            let nextViewController =  self.storyboard!.instantiateViewController(withIdentifier: "MainTabBar")       as! MainTabBarController
            self.present(nextViewController,animated:true,completion:nil)

        }
    }
}

extension PostNewJobViewController: getLocaition{
    func onsetLocation(location: String, lat: Double, lng: Double) {
        addressTextField.text = location
        self.lat = lat
        self.lng = lng
    }
}

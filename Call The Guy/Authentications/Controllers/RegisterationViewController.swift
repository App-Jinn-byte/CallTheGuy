//
//  RegisterationViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 14/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    let manager = CLLocationManager() // to get user location
    var latitude = 0.0
    var longitude = 0.0
    var mapAddress = ""
    
    var catarray: [[String:Int]] = []
    
    var ref:DatabaseReference!
    var data = SelectCategoriesViewController()
    //Mark:- Location Variables
    
    //Mark:- Values from Previous Controller
    @IBOutlet weak var topMarginToretypePassword: NSLayoutConstraint!
    public var imageExtension: String?
    public var byteArray: String?
    public var userTypeId:Int?
    public var deviceId: String?
    public var isImageAttached: Bool = false
    var isCheck: Bool = false
    var categoriesId = [Int]()
    var controller: String?
    var categoriesName = [String]()
    var imageString = ""
    var imagePaths = ""
    var id : Int?
    var name = ""
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var attachFileButton: UIButton!
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var categorySelectField: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categorySelectStackView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBAction func mapButton(_ sender: Any) {
        
        // addressTextField.text = mapAddress
    }
    
    @IBAction func selctCategoryBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Category") as? SelectCategoriesViewController
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkboxButton(_ sender: Any) {
        if checkBoxBtn.backgroundImage(for: .normal) == UIImage.init(named: "emptyCheckbox"){
            checkBoxBtn.setBackgroundImage(UIImage.init(named: "fillCheckBox"), for: .normal)
            isCheck = true
        }
        else{
            checkBoxBtn.setBackgroundImage(UIImage.init(named: "emptyCheckbox"), for: .normal)
            isCheck = false
        }
    }
    @IBAction func getLocationBtn(_ sender: Any) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var pvc = storyboard.instantiateViewController(withIdentifier: "GetLocation") as! GetLocationViewController
        pvc.delegate = self
        pvc.view.frame.size.height = 300
        self.present(pvc, animated: true, completion: nil)
    }
    
    
    // Mark :- Select image using imageViewController and then convert it into Data or NSDATA format
    @IBAction func attachFilebutton(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
        
    }
    
    // Mark:- Did  Finish Func for image picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        userImageview.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        
        let image0 = userImageview.image
        //print(image0)
        //let data = image0?.pngData()
        //print(data)
        let data1 = image0?.jpegData(compressionQuality: 0.9)
        let uiImage = UIImage(data: data1! as Data)
        //print(data!)
        //print(data1!)
        //print(uiImage!)
        var typeArray = getImageString(imageData: data1! as NSData)
        print(typeArray)
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL)
            // print(imgUrl)
            // print(imgName)
            let  myStringArr = imgName.components(separatedBy: ".")
            // print(myStringArr)
            imageExtension = myStringArr[1]
            print(imageExtension)
            
            // print(documentDirectory)
            //  print(localPath)
            //  print(image)
            //  print(data)
        }
        
        isImageAttached = true
        
        //        let image = userImageview.image
        //        print(image!)
        //        let imageData = image!.pngData()
        //        print(imageData!)
        //        let image1 = userImageview.image!.pngData() as NSData?
        //        let imageBack = UIImage(data: image1! as Data)
        //        print(imageBack!)
        //        //print(image1!)
        //        let count = imageData!.count / sizeof(UInt8.self)
        //        print(count)
        //        var bytes = [UInt8](repeating: 0, count: count)
        //        let length = bytes.count * MemoryLayout<UInt8>.stride
        //
        //        print(bytes, String(bytes: bytes, encoding: .utf8)!)
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Mark:- Converting data into byte array of base 64
    
    func getImageString(imageData:NSData) -> String
    {
        
        
        // the number of elements:
        //let count = imageData.length / sizeof(UInt8.self)
        let count1 = imageData.length / sizeof(UInt16.self)
        
        // create array of appropriate length:
        //var bytes = [UInt8](repeating: 0, count: count)
        var bytes1 = [UInt16](repeating: 0, count: count1)
        
        // copy bytes into array
        //imageData.getBytes(&bytes, length:count * sizeof(UInt8.self))
        imageData.getBytes(&bytes1, length:count1 * sizeof(UInt16.self))
        
        //let byteArray:NSMutableArray = NSMutableArray()
        let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
        //print(imageStr)
        //        for i in 0..<count1 {
        //          //  byteArray.add(NSNumber(value: bytes[i]))
        //        }
        
        byteArray = imageStr
        
        return imageStr
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let name = nameTextField.text
        let phone = phoneTextField.text
        let location = addressTextField.text!
        let email = emailTextField.text
        let password1 = passwordTextField.text
        let password2 = retypePasswordTextField.text
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        print(deviceId)
        let userType_Id = self.userTypeId
        print(longitude)
        print(latitude)
        print(catarray)
        
        if(password1 == "" || password2 == "" || name == "" || location == "" || email == ""){
            Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
            return
        }
        else if !(email!.isValidEmail){
            Constants.Alert(title: "ERROR", message: "Invalid Email address...", controller: self)
            return
        }
        else if !(phone!.isValidPhone){
            Constants.Alert(title: "ERROR", message: "Phone format not correct...", controller: self)
            return
        }
            
        else if(password1 != password2){
            Constants.Alert(title: "ERROR", message: "Password is not matching...", controller: self)
            return
        }
        else if (isImageAttached == false){
            
            Constants.Alert(title: "Attach File", message: "Please! attach image..", controller: self)
            return
        }
        else if (self.catarray.count == 0 && userTypeId == 4){
            
            Constants.Alert(title: "Select Categories", message: "Please! Select Categories", controller: self)
            return
        }
        else if (isCheck == false){
            Constants.Alert(title: "Attention!", message: "Please mark terms and conditions box", controller: self)
            print(isCheck)
            return
        }
        if Reachability.isConnectedToNetwork(){
            if(Constants.userTypeId == 3){
                let param:[String:Any] = ["UserName":name!,
                                          "Mobile":phone!,
                                          "Location": location,
                                          "Email":email!,
                                          "Password":password1!,
                                          "UserTypeId": userType_Id!,
                                          "DeviceId":deviceId,
                                          "Lat":latitude,
                                          "Lng":longitude]
                print(param)
                APIRequest.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            else{
                let param:[String:Any] = ["UserName":name!,"Mobile":phone!,"Location": location, "Email":email!,"Password":password1!,"UserTypeId": userType_Id!,"DeviceId":deviceId, "Lat":latitude,"Lng":longitude,"ContractorCategories":self.catarray]
                print(param)
                
                let url = "https://www.calltheguy.co.za/api/Mobile/Register"
                APIRequest.POSTRequestJsonString(url: url, parameters: param, completion: APIRequestCompleted)
                
                
                APIRequest.Test(parameters: param, completion: APIRequestCompleted)
                // APIRequest.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            
            activityIndicator.startAnimating()
            
            //APIRequest.Registeration(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
        
    }
    
    // Mark:- location Manager Function coordinates and address
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        self.manager.stopUpdatingLocation()
        // latitude = location.coordinate.latitude
        // longitude = location.coordinate.longitude
        print(longitude)
        print(latitude)
        // mapAddress = ("\(longitude)" + "\(latitude)")
        
        
        //mark 1
        //        let geocoder = CLGeocoder()
        //        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        //            if (error != nil){
        //                print("error in reverseGeocode")
        //            }
        //            let placemark = placemarks! as [CLPlacemark]
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
        //                self.mapAddress = "\(placemark.name!),\(placemark.postalCode ?? ""),\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
        //                print(self.mapAddress)
        //            }
        //       }
        
        //here you will get the core location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // Mark:- Delegate Methods For Location Manager
        if (userTypeId == 3){
            topMarginToretypePassword.constant = 20
        }
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let vc = SelectCategoriesViewController()
        vc.delegate = self
        //addressTextField.delegate = self
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
        
        nameTextField.layer.cornerRadius = nameTextField.frame.size.height/2
        nameTextField.clipsToBounds = true
        
        phoneTextField.layer.cornerRadius = phoneTextField.frame.size.height/2
        phoneTextField.clipsToBounds = true
        
        addressTextField.layer.cornerRadius = addressTextField.frame.size.height/2
        addressTextField.clipsToBounds = true
        
        emailTextField.layer.cornerRadius = emailTextField.frame.size.height/2
        emailTextField.clipsToBounds = true
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.height/2
        passwordTextField.clipsToBounds = true
        
        retypePasswordTextField.layer.cornerRadius = retypePasswordTextField.frame.size.height/2
        retypePasswordTextField.clipsToBounds = true
        
        attachFileButton.layer.cornerRadius = attachFileButton.frame.size.height/2
        attachFileButton.clipsToBounds = true
        // attachFileButton.layer.borderWidth = 1.0
        // attachFileButton.layer.borderColor = UIColor.white.cgColor
        
        registerButton.layer.cornerRadius = registerButton.frame.size.height/2
        registerButton.clipsToBounds = true
        
        categorySelectField.layer.cornerRadius = categorySelectField.frame.size.height/2
        categorySelectField.clipsToBounds = true
        
        
        self.userImageview.layer.cornerRadius = self.userImageview.frame.size.width / 2;
        self.userImageview.clipsToBounds = true;
        
        userImageview.clipsToBounds = true
        
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        nameTextField.setLeftPaddingPoints(40)
        phoneTextField.setLeftPaddingPoints(40)
        addressTextField.setLeftPaddingPoints(40)
        emailTextField.setLeftPaddingPoints(40)
        retypePasswordTextField.setLeftPaddingPoints(40)
        passwordTextField.setLeftPaddingPoints(40)
        //categorySelectField.setLeftPaddingPoints(40)
        let spacing: CGFloat = 43.0
        self.categorySelectField.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        categorySelectField.contentHorizontalAlignment = .left
        
        //attachFileButton.addDashedBorder()
        print("register\(userTypeId)")
        
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        self.hideKeyboardWhenTappedAround()
        UITextField.appearance().tintColor = .white
        
        if (userTypeId == 3){
            categorySelectStackView.isHidden = true
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        //        if controller == "categories"{
        //            print(categoriesName)
        //            print(categoriesId)
        //            if (categoriesName.count != 0){
        //                //            let spacing: CGFloat = 22.0
        //                //            self.categorySelectField.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        //                self.categorySelectField.setTitle(categoriesName.joined(separator: ", " ), for: .normal)
        //            }
        //            print(categoriesId.count)
        //            for i in 0..<categoriesId.count{
        //                var ContractorCategories: [String:Int] = [String:Int]()
        //                ContractorCategories["CategoryId"] = categoriesId[i]
        //                Catarray.append(ContractorCategories) as AnyObject
        //            }
        //            print(Catarray)
        //        }
        //        self.controller = ""
        //    let vc = SelectCategoriesViewController()
        //    vc.delegate = self
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let registerationResponse = try decoder.decode(RegisterationModelResponse.self, from: data)
                print(registerationResponse.CNIC)
                print(registerationResponse.Email)
                print(registerationResponse.UserName)
                print(registerationResponse.UserId)
                print(registerationResponse.ImagePath)
                
                self.id = registerationResponse.UserId
                self.name = registerationResponse.UserName
                
                    let param:[String:Any] = ["id": registerationResponse.UserId, "Extension":".\(imageExtension!)","Image":byteArray!]
                    
                    
                    APIRequest.SaveImage(parameters: param, completion: APIRequestCompletedForImage)
                
               
                
                    
                    activityIndicator.stopAnimating()
                    
                    
                    Constants.Alert(title: "USER REGISTERED", message: "\(registerationResponse.UserName) Successfully Registered", controller: self, action: handlerSuccessAlert())
                    
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
                    
                    let imageResponse = try decoder.decode(ImageModelResponse.self, from: data)
                    print(imageResponse.Id)
                    print(imageResponse.Path)
                    self.imagePaths = imageResponse.Path
                    print(imagePaths)
                    
                    if (self.imagePaths != ""){
                        var imagePath = self.imagePaths
                        imagePath = String(imagePath.dropFirst(3))
                        imagePath = "https://www.calltheguy.co.za/"+imagePaths
                        self.imageString = imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                        print(imageString)
                        self.ref.child("users").child("\(self.id!)").setValue([
                            "id":"\(self.id!)",
                            "name":"\(self.name)",
                            //"senderId":"2345",
                            "profileImage":"\(imagePaths)"
                            ])
                    }
                    
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
        
        //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //        if textField == addressTextField {
        //            return false; //do not show keyboard nor cursor
        //        }
        //        return true
        //    }
        
        func sizeof<T:FixedWidthInteger>(_ intType:T.Type) -> Int {
            return intType.bitWidth/UInt8.bitWidth
        }
        
        func handlerSuccessAlert() -> (UIAlertAction) -> () {
            return { action in
                // self.performSegue(withIdentifier: "Reset", sender: nil)
                let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")   as! LogInViewController
                
                self.present(nextViewController,animated:true,completion:nil)
            }
        }
    }
    extension RegisterationViewController: getLocaition{
        func onsetLocation(location: String, lat: Double, lng: Double) {
            addressTextField.text = location
            latitude = lat
            longitude = lng
        }
    }
    
    extension RegisterationViewController: categoriesProtocol{
        func sendName(catNames: [String]) {
            
            self.categoriesName = catNames
            self.categorySelectField.setTitle(categoriesName.joined(separator: ", " ), for: .normal)
        }
        
        func sendId(catId: [Int]) {
            self.categoriesId = catId
            print(categoriesId.count)
            for i in 0..<categoriesId.count{
                var contractorCategories: [String:Int] = [String:Int]()
                contractorCategories["CategoryId"] = categoriesId[i]
                catarray.append(contractorCategories)
            }
            print(catarray)
        }
        
}

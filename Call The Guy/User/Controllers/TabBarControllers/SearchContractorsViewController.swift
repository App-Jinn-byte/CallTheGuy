//
//  SearchContractorsViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 03/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//
import MapKit
import UIKit
import CoreLocation

class SearchContractorsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    var contList = [contractorsList]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabelValue: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var resgisterButton: UIButton!
    var catId = 0
    var sliderValue = 0
    let locationManager = CLLocationManager()
    var lat = 0.0
    var lng = 0.0
     var catPicker: UIPickerView?
    var newArrayList = [CategoriesListModelResponse]()
    @IBAction func mapButton(_ sender: Any) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var pvc = storyboard.instantiateViewController(withIdentifier: "GetLocation") as! GetLocationViewController
        pvc.delegate = self
        pvc.view.frame.size.height = 300
        self.present(pvc, animated: true, completion: nil)
    }
    @IBOutlet weak var selectCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
        setLayout()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func slider(_ sender: UISlider) {
        sliderValue = Int(sender.value)
        sliderLabelValue.text =  String(sliderValue) + "KM"
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        var name = nameTextField.text
        let category = selectCategoryTextField.text
        let catid = catId
        let address = "\(lat)_\(lng)"
        let distance = sliderLabelValue.text
        let distance1 = distance!.dropLast(2)
        
//        if (name == "") {
//            name = " "
//        }
        if(category == "" || address == "")
        {
            Constants.Alert(title: "Error", message: "Please Select Categoty!", controller: self)
            return
        }
        
        let param:[String:Any] = ["name":name ?? "","categoryId":catid ,"location":address,"distance":distance1]
        
        if Reachability.isConnectedToNetwork(){
            activityIndicator.startAnimating()
            APIRequest.SearchContractor(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
        
    }
    
    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let contractors = try decoder.decode(SearchContractorModel.self, from: data)
                contList = contractors.list
//                print(contractors.list[1].UserName)
//                print(contractors.list[0].UserName)
//                print(contList[0].UserId)
//                print(contList[0])
//                print(contList.count)
                activityIndicator.stopAnimating()
//                let nextViewController =  self.storyboard!.instantiateViewController(withIdentifier: "SearchContractors") as! SearchContractorsListViewController
//                nextViewController.modalTransitionStyle = .partialCurl
//                self.present(nextViewController,animated:true,completion:nil)
                
                performSegue(withIdentifier: "Search", sender: nil)
                
            }
            catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "Hello", controller: self)
            }
        }
        else{
            Constants.Alert(title: "Error", message: "Error", controller: self)
        }
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
//       // lat = locValue.latitude
//       // lng = locValue.longitude
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        print(lat)
//        print(lng)
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(locations[0]) { (placemarks, error) in
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
//                self.locationManager.stopUpdatingLocation()
//           //     self.addressTextField.text = "\(placemark.name!),\(placemark.postalCode ?? ""),\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
//             //   print(self.addressTextField)
//            }
//        }
//
//    }
    
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
        
        nameTextField.layer.cornerRadius = nameTextField.frame.size.height/2
        nameTextField.clipsToBounds = true
        
        selectCategoryTextField.layer.cornerRadius = selectCategoryTextField.frame.size.height/2
        selectCategoryTextField.clipsToBounds = true
        
        addressTextField.layer.cornerRadius = addressTextField.frame.size.height/2
        addressTextField.clipsToBounds = true
    
        
        resgisterButton.layer.cornerRadius = resgisterButton.frame.size.height/2
        resgisterButton.clipsToBounds = true
        
        resgisterButton.layer.borderWidth = 1.0
        resgisterButton.layer.borderColor = UIColor.white.cgColor
        
        nameTextField.setLeftPaddingPoints(40)
        selectCategoryTextField.setLeftPaddingPoints(40)
        addressTextField.setLeftPaddingPoints(40)
        selectCategoryTextField.setLeftPaddingPoints(40)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc  = segue.destination as! SearchContractorsListViewController
        vc.user = Constants.userTypeId
        vc.contList =  self.contList
    }

}
extension SearchContractorsViewController: getLocaition{
    func onsetLocation(location: String, lat: Double, lng: Double) {
        addressTextField.text = location
       self.lat = lat
        self.lng = lng
    }
    
    
}

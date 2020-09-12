//
//  GetLocationViewController.swift
//  Call The Guy
//
//  Created by JanAhmad on 07/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import DropDown

protocol getLocaition: class {
    func onsetLocation(location: String, lat: Double ,lng: Double)
}
class GetLocationViewController: UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchBarContainer: UIView!
    
    var userSearch = ""
    var addressDropdown = DropDown()
    private var addressPredections = [PredictionViewModel]()
    weak var delegate:getLocaition?
    var kCameraLatitude   = 0.0
    var kCameraLongitude  = 0.0
    var locationManager = CLLocationManager()
    private var isDropdownSet: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate   = self
        initializeTheLocationManager()
        self.bgView.layer.masksToBounds = false
        self.bgView.layer.shadowColor = UIColor.black.cgColor
        self.bgView.layer.shadowOpacity = 0.4
        bgView.layer.cornerRadius = 10
        self.bgView.layer.shadowRadius = 6
        self.bgView.layer.shadowOffset = CGSize(width: 1, height: 0)
        
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height/2
        doneBtn.clipsToBounds = true
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initializeTheLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.delegate = self
        }
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    private func generatePin() {
        let currentUserLocation = GMSCameraPosition.camera(withLatitude: kCameraLatitude,
                                                           longitude: kCameraLongitude,
                                                           zoom: 15)
        mapView.camera = currentUserLocation
        let coordinate = CLLocationCoordinate2D(latitude: kCameraLatitude, longitude: kCameraLongitude)
        let marker = GMSMarker(position: coordinate)
        marker.title   = ""
        marker.snippet = ""
        marker.isDraggable = true
        marker.map = mapView
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            print(lines)
            var currentAddress = lines.joined(separator: "\n")
            self.addressLabel.text = currentAddress
            print(self.kCameraLatitude)
            print(self.kCameraLongitude)
            print(response?.firstResult())
            self.delegate?.onsetLocation(location: currentAddress,lat: self.kCameraLatitude,lng: self.kCameraLongitude)
        }
    }
    
}
extension GetLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        cameraMoveToLocation(toLocation: locValue)
        kCameraLatitude  = locValue.latitude
        kCameraLongitude = locValue.longitude
        
        //mapView.settings.compassButton = true
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        //mapView.mapType = .satellite
        mapView.animate(to: mapView.camera)
        locationManager.stopUpdatingLocation()
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        generatePin()
        reverseGeocodeCoordinate(locValue)
        
    }
}

extension GetLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        kCameraLatitude = coordinate.latitude
        kCameraLongitude = coordinate.longitude
        
        reverseGeocodeCoordinate(coordinate)
        self.mapView.clear()
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        mapView.animate(to: cameraPosition)
        
        let marker = GMSMarker(position: coordinate)
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
    }
}
extension GetLocationViewController {
    func locationDropdownSetup() {
        if isDropdownSet {
            isDropdownSet = false
            addressDropdown.subviews.last?.frame.origin.y = searchBarContainer.frame.origin.y + 35
        }
//        addressDropdown.bottomOffset = CGPoint(x: 0, y:(addressDropdown.anchorView?.plainView.bounds.height)!)
//            = viewFrame//CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y, width: viewFrame.width - 20, height: 200)
        addressDropdown.direction = .bottom
    }
    
//    func usersDropdownSetup() {
//        let viewFrame = friendsTextField.frame
//        usersDropdown.anchorView?.plainView.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y, width: viewFrame.width - 20, height: 200)
//        usersDropdown.direction = .bottom
//
//        userNames = usersList.compactMap({$0.userName})
//        usersDropdown.selectionAction = { (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
//            self.userSearch = ""
//            let selected = self.filteredUserNames[index]
//            self.selectedUserNames.append(selected)
//            self.friendsTextField.text = self.selectedUserNames.joined(separator: ",")
//        }
//    }
//
//    func collectionViewContainerSetup(with state: AddNewButtonState) {
//        collectionViewContainerHeight.constant = state == .show ? 90 : 0
//        imagesCollectionState = imagesCollectionState == .hide ? .show : .hide
//        view.layoutIfNeeded()
//    }
}
extension GetLocationViewController {
    
//    private func populateCheckInDetails() {
//
//        checkInDataset.selectedImages = selectedImages
//        for user in usersList {
//            for selected in selectedUserNames {
//                if selected == user.userName {
//                    checkInDataset.tagedUser.append(user)
//                }
//            }
//        }
//
//        // Ready for data insertion in DB.
//    }
//
//    private func fetchUsers() {
//        self.ref = Database.database().reference()
//        self.ref.child("Sighted_Users_Data").observeSingleEvent(of: .value) { (users) in
//
//            for user in users.children {
//                guard let userModel = user as? DataSnapshot else {return}
//                let userVM = User(snapshot: userModel)
//                self.usersList.append(userVM)
//            }
//            self.usersDropdownSetup()
//        }
//    }
    
    private func autoCompletePlaces(with input: String) {
        
        autoComplete(input: input) { (predictions, error) in
            
            if error == nil {
                guard let viewModel = predictions?.compactMap({$0.viewModel}) else {return}
                self.addressPredections = viewModel
                let address = self.addressPredections.compactMap({$0.detail})
                self.addressDropdown.dataSource = address
                self.addressDropdown.show()
                if self.addressDropdown.subviews.last?.frame.origin.y != 0 {
                    self.locationDropdownSetup()
                }
                self.addressDropdown.selectionAction = { (index: Int, item: String) in
                    print("Selected item: \(item) at index: \(index)")
                    let selected = self.addressPredections[index]
                    self.addressValidation(with: selected.detail, placeId: selected.id)
                }
            }else {
                debugPrint(error?.localizedDescription ?? "Something went wrong")
            }
        }
    }
    
    private func addressValidation(with input: String, placeId: String) {
        
        geoCodeValidation(input: input, placeId: placeId) { (validateAddress, error) in
            
            if error == nil {
                guard let predctions = validateAddress?.results.first else { return }
                self.addressLabel.text = predctions.address
                if let coordinate = predctions.geometryLocation?.location {
                    self.kCameraLatitude = coordinate.latitude
                    self.kCameraLongitude = coordinate.longitude
                    self.mapView.clear()
                    self.generatePin()
                }
            }else {
                debugPrint(error?.localizedDescription ?? "Something went wrong")
            }
        }
    }
}
extension GetLocationViewController {
    
    typealias AutocompleteCompletion = ([Prediction]?, AppError?) -> ()
    
    func autoComplete(input: String, completion: @escaping AutocompleteCompletion) {
        
        _ = APIManager.googleApi(CreateCheckInAPI.autoComplete(input: input), dataReturnType: PlacesAutocomplete.self, success: { (place,pages)  in
            
            completion(place?.predictions, nil)
            
        }, failure: { (error) in
            
            completion(nil, error)
        })
    }
    
    typealias GeoCodeCompletion = (Geocode?, AppError?) -> ()
    
    func geoCodeValidation(input: String, placeId: String, completion: @escaping GeoCodeCompletion) {
        
        _ = APIManager.googleApi(CreateCheckInAPI.geocode(input: input, placeId: placeId), dataReturnType: Geocode.self, success: { (place,pages) in
            
            completion(place, nil)
            
        }, failure: { (error) in
            
            completion(nil, error)
        })
    }
}
extension GetLocationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressTextField {
            self.addressDropdown.show()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == addressTextField {
            autoCompletePlaces(with: (textField.text ?? "")+string)
        }
//        if textField == friendsTextField {
//            if string.isEmpty && !userSearch.isEmpty {
//                userSearch.removeLast()
//            }else {
//                userSearch.append(string)
//            }
//            filteredUserNames = userNames.filter({$0.contains(userSearch)})
//            self.usersDropdown.dataSource = filteredUserNames
//            self.usersDropdown.show()
//        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.userSearch = ""
        self.addressDropdown.hide()
       
    }
}


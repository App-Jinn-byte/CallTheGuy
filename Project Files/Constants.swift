//
//  Constants.swift
//  Call The Guy
//
//  Created by JanAhmad on 14/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
import UIKit

let googleMaps = "https://maps.googleapis.com/maps/api"
let googleMap = "http://maps.googleapis.com/maps/api"

class Constants {
    
    public static var userTypeId = 0
    public static var userName = ""
    public static var userEmail = ""
    public static var userId = 0
    public static var userProfile = ""
    
    public static var statusCode = 0
    public static var statusMessage = ""
    public static var catId = 0
    public static var catName = ""
    public static var catList = [CategoriesListModelResponse]()
    public static var loginErrorMessage = "Invalid username or password!"
    public static var forgotPasswordErrorMessage = "Invalid username"
    
    
    public static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        //      let emailRegEx = "[A-Z0-9a-z._%+-]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    public static func Alert(title:String,message:String,controller:UIViewController){
        let alert = UIAlertController.init(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public static func Alert(title:String,message:String,controller:UIViewController, action: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController.init(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: action))
        controller.present(alert, animated: true, completion: nil)
    }
    public static func Alert1(title:String,message:String,controller:UIViewController, action: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController.init(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: action))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (action) in
            
        }))
        controller.present(alert, animated: true, completion: nil)
    }
}

//
//  APIResponseUtil.swift
//  iMed
//
//  Created by M.Bilal on 8/6/17.
//  Copyright © 2017 Bilal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APIResponse {
    
    public static func isValidResponse(viewController: UIViewController,response: Any?, error: Error?, renderError: Bool = false,dismissLoading: Bool = true) -> Bool {
        
        var isValidResponse = false
        var message = ""
        
        //   print(response)
        
        if dismissLoading {
            
        }
        if error != nil {
            message = "Constants.GenericError"
            
        } else {
            if response != nil {
                isValidResponse = true
            }
        }
        
        if !isValidResponse && message.count > 0 && renderError {
            //            ViewControllerUtil.showAlertView(viewController: viewController, title: "Wait", message: message, successTitle: "OK")
        }
        
        return isValidResponse
    }
}

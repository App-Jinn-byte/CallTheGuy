//
//  APIRequestUtil.swift
//  iMed
//
//  Created by M.Bilal on 8/6/17.
//  Copyright © 2017 Bilal. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestCompletion = (_ response: Any?, _ error: Error?) -> Void

class APIRequest {
    
    
    public static let BASE_URL = "https://www.calltheguy.co.za/api/Mobile/"
    
    public static func Login(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Login", parameters: parameters, completion: completion)
    }
    
    public static func ForgotPassword(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"validateByEmail", parameters: parameters, completion: completion)
    }
    
    public static func ResetPassword(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"ResetPassword", parameters: parameters, completion: completion)
    }
    
    public static func Registeration(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Register", parameters: parameters, completion: completion)
    }
    
    public static func Test(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Register", parameters: parameters, completion: completion)
    }
    
    public static func SaveImage(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"SaveCustomerImages", parameters: parameters, completion: completion)
    }
    
    public static func GetAllCategories(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllCategoriesWithAds",  completion: completion)
        }
    public static func GetReviews(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetRemarksForUser?userId=\(Constants.userId)",  completion: completion)
    }
    
    public static func GetBlogs(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllBlogs",  completion: completion)
    }
    
    public static func SearchContractor(parameters: Parameters,completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"FindContractor",parameters: parameters,completion: completion)
    }
    
    
    public static func GetAllContractors(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"getUserByCategoryId?catId=\(Constants.catId)", completion: completion)
    }
    
    public static func GetJobs(parameters: Parameters,completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"GetJobByStatus",parameters: parameters,completion: completion)
    }
    
    public static func CreateDispute(parameters: Parameters,completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"CreateDispute",parameters: parameters,completion: completion)
    }
    
    public static func SaveDisputeImage(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"SaveDisputeImages", parameters: parameters, completion: completion)
    }
    public static func Disputes(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllDisputes?userId=\(Constants.userId)",completion: completion)
    }
    public static func CloseJob(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"CloseJob", parameters: parameters, completion: completion)
    }
    public static func FetchAllContractors(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllUsers?typeId=4", completion: completion)
    }
    public static func CreateAppointment(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Createappointment", parameters: parameters, completion: completion)
    }
    public static func GetAllAppointments(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAppointmentsByUserId?userId=\(Constants.userId)", completion: completion)
    }
    public static func CreateJob(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"CreateJobs", parameters: parameters, completion: completion)
    }
    public static func SaveJobImage(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"SaveJobImages", parameters: parameters, completion: completion)
    }
    public static func GetJobAppliedContractors(jobValue:Int,completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetJobAppliedContractors?jobId=\(jobValue)", completion: completion)
    }
    public static func AcceptJob(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"AcceptJob", parameters: parameters, completion: completion)
    }
    public static func getUserId(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"getUserById?userId=\(Constants.userId)", completion: completion)
    }
    public static func GetAvailableJobs(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAvailableJobForContractor?userId=\(Constants.userId)", completion: completion)
    }
    public static func FetchAllUsers(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllUsers?typeId=3", completion: completion)
    }
    public static func GetContractorJobs(parameters: Parameters,completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"GetContractorJobByStatus",parameters: parameters,completion: completion)
    }
    public static func CloseAppointment(value:Int,parameters: Any?,completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"CloseAppointment?appointmentId=\(value)",parameters: parameters as! Any as! Parameters,completion: completion)
    }
    public static func getUserId1(id: Int, completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"getUserById?userId=\(id)", completion: completion)
    }
    public static func GetReviews1(id: Int, completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetRemarksForUser?userId=\(id)",  completion: completion)
    }
    public static func ApplyJob(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"ApplyJob", parameters: parameters, completion: completion)
    }
    public static func Rating(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Rate", parameters: parameters, completion: completion)
    }
    
    
    typealias saveOrderCompletion = ([String:Any]?, Error?) -> ()
    
    class func POSTRequestJsonString(url: String, parameters: Parameters,
                                     completion: @escaping saveOrderCompletion) {
        
        
        guard let urlRequest = URL(string: url)else{return }
        let hearder: HTTPHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(urlRequest, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: hearder).responseJSON { response in
            switch response.result
            {
            case .success(let json):
                let jsonDic = json as? [String: Any]
                completion(jsonDic,nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    
    
}
extension APIRequest {
    
    fileprivate static func GETRequest(url: String, completion: @escaping RequestCompletion) {
        
        
        guard let urlRequest = URL(string: url)else{return }
        var request = URLRequest(url: urlRequest )
        request.httpMethod = "GET"
        
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        
        Alamofire.request(request).responseJSON { response in
            
            switch (response.result) {
            case .success:
                
                completion(response.result.value, nil)
                
                break
                
                //success code here
                
            case .failure(let error):
                
                completion(nil, response.result.error)
                
                break
                
                //failure code here
            }
        }
    }
    
    fileprivate static func POSTRequest(url: String, parameters: Parameters,
                                        completion: @escaping RequestCompletion) {
        
//        Alamofire.request(urlRequest, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: hearder).responseJSON { response in
//            switch response.result
        
        guard let urlRequest = URL(string: url)else{return }
        var request = URLRequest(url: urlRequest )
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = nil
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
    
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        Alamofire.request(request).responseJSON { response in
            print(response.response?.statusCode)
            guard let statusCode =  response.response?.statusCode else{return}
            Constants.statusCode = statusCode
            print(statusCode)
            print(response.result)
            print(response.result.value!)
            
            //Mark:- pending work on the basis of status code dynamically alert message from response
          if (Constants.statusCode == 500 ){
                //Constants.statusMessage = response.result.value.
                Constants.statusMessage = "Invalid Credentials"
            }
          else if (Constants.statusCode == 403){
            Constants.statusMessage = "Email Already exist..."
            }
          else{
           Constants.statusMessage = "Connection timeout"
            }
            
            switch (response.result) {
            case .success:
                
                completion(response.result.value, nil)
                
                break
                
                //success code here
                
            case .failure(let error):
                
                completion(nil, response.result.error)
                
                break
                
                //failure code here
            }
        }
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}



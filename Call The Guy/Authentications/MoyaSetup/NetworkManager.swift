//
//  NetworkManager.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
import Moya

typealias APISuccess<ReturnedObject: Decodable> = (ReturnedObject?,_ totalPages:Int?) -> ()
typealias APIFailure = (AppError) -> ()

class APIRequestt {
    var cancellable: Cancellable!
    var identifier = UUID().uuidString
}


class APIManager {
    
    public var requests = [APIRequestt]()
    
    static let shared = APIManager()
    private init() {}
    
    @discardableResult static func callApi<Target: TargetType, ReturnedObject: Decodable>(_ target: Target, dataReturnType: ReturnedObject.Type, success: @escaping APISuccess<ReturnedObject>, failure: @escaping APIFailure) -> String {
        let provider = MoyaProvider<Target>(plugins: [NetworkLoggerPlugin(verbose: true)])
        
        let apiRequest = APIRequestt()
        apiRequest.cancellable = provider.request(target, completion: { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(APIResponsee<ReturnedObject>.self, from: response.data)
                    if Int(results.code!) == 200 {
                        success(results.data, results.totalPages)
                    }
                    else {
                        let apiError = AppError(description: results.message ?? "")
                        failure(apiError)
                    }
                } catch {
                    let apiError = AppError(description: error.localizedDescription)
                    failure(apiError)
                }
                break
            case .failure(let error):
                let apiError = AppError(description: error.localizedDescription)
                failure(apiError)
            }
            shared.removeRequestFromList(apiRequest)
        })
        shared.requests.append(apiRequest)
        return apiRequest.identifier
    }
    
    func removeRequestFromList(_ apiRequest: APIRequestt) {
        requests = requests.filter { $0.identifier != apiRequest.identifier}
    }
    
    static func googleApi<Target: TargetType, ReturnedObject: Decodable>(_ target: Target, dataReturnType: ReturnedObject.Type, success: @escaping APISuccess<ReturnedObject>, failure: @escaping APIFailure) {
        let provider = MoyaProvider<Target>(plugins: [NetworkLoggerPlugin(verbose: true)])
        
        let apiRequest = APIRequestt()
        //        print("API_Request sending: \(apiRequest.identifier)")
        apiRequest.cancellable = provider.request(target, completion: { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(ReturnedObject.self, from: response.data)
                    success(results, 0)
                } catch {
                    let apiError = AppError(description: error.localizedDescription)
                    failure(apiError)
                }
                break
            case .failure(let error):
                let apiError = AppError(description: error.localizedDescription)
                failure(apiError)
            }
            shared.removeRequestFromList(apiRequest)
        })
        shared.requests.append(apiRequest)
    }
    
    //    static func googleApi<Target: TargetType, ReturnedObject: Decodable>(_ target: Target, dataReturnType: ReturnedObject.Type, success: @escaping APISuccess<ReturnedObject>, failure: @escaping APIFailure) -> MoyaProvider<Target> {
    //        let provider = MoyaProvider<Target>(plugins: [NetworkLoggerPlugin(verbose: true)])
    //
    //        provider.request(target, completion: { result in
    //            switch result {
    //            case .success(let response):
    //                do {
    //                    let results = try JSONDecoder().decode(ReturnedObject.self, from: response.data)
    //
    //                    if result.error == nil {
    //                        succes(results.self)
    //                    }
    //                    else {
    //                        let apiError = AppError(description: results.error ?? String.empty)
    //                        failure(apiError)
    //                    }
    //                } catch {
    //                    let apiError = AppError(description: error.localizedDescription)
    //                    failure(apiError)
    //                }
    //                break
    //            case .failure(let error):
    //                let apiError = AppError(description: error.localizedDescription)
    //                failure(apiError)
    //            }
    //        })
    //        return provider
    //    }
    
    
    
    static func cancelAll() {
        shared.requests.forEach {
            //            print("API_Request cancelling: \($0.identifier)")
            $0.cancellable.cancel()
        }
        shared.requests.removeAll()
    }
    
    static func cancelRequest(identifier: String) {
        if let request = shared.requests.first(where: { $0.identifier == identifier }) {
            request.cancellable.cancel()
            shared.removeRequestFromList(request)
        }
        
    }
}

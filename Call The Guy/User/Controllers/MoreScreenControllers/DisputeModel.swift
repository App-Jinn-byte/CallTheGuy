//
//  DisputeModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/11/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
import Alamofire

struct DisputeModelResponse: Codable {
    
    let DisputesList:[disputeList]
}

struct disputeList: Codable{
    let Disputes: list
    let Detail: String?
}

struct list: Codable{
    let DisputeId: Int
    let JobId: Int
    let Title: String?
    let Description: String?
    let Image: String?
    let Status: Int
    let IsActive: Bool
    let IsApproved: Bool
    let CreatedOn: String?
    let CreatedBy: Int
    let UpdatedOn: String?
    let UpdatedBy: String?
}


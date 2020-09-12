//
//  RegisteratioModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 17/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation

struct RegisterationModelResponse: Codable {
    
    let UserId: Int
    let UserName: String
    let Email: String
    let Password: String
    let PhoneNumber: String?
    let Mobile: String?
    let CNIC: String?
    let City: String?
    let Country: String?
    let LocationCord: String?
    let LocationName: String?
    let ImagePath: String?
    let DeviceId: String?
    let UserTypeId: Int
    let IsApproved: Bool?
    let Status: String?
    let CreatedBy: String?
    let CreatedOn: String?
    let UpdatedBy: String?
    let UpdatedOn: String?
    let IsActive: Bool?
    let CategoryId: String?
    let DistanceFromOrigin: String?
    let Lat: String?
    let Lng: String?
    let IsAvailable: Bool?
    let IsSubscriber: Bool?
    let CertificatePath: String?
    let ContractorCategories: [Contracter]?
    let ForumReplies: [String]?
    let JobHistories: [String]?
    let UserType: String?
}
struct Contracter: Codable{
    let ContractorCategoryId: Int?
    let ContractorId: Int?
    let CategoryId: Int?
    let ModifiedOn: String?
    let ModifiedBy: String?
}

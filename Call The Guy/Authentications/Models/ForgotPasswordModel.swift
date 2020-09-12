//
//  ForgotPasswordModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.

import Foundation

struct ForgotPasswordModelResponse: Codable {
    
    let UserId: Int
    let UserName: String
    let Email: String
    let Password: String
    let PhoneNumber: String?
    let Mobile: String?
    let CNIC: String?
    let LocationCord: String?
    let LocationName: String?
    let ImagePath: String?
    let DeviceId: String?
    let UserTypeId: Int
    let IsApproved: Bool?
    let IsActive: Bool?
    let IsAvailable: Bool?
    let IsSubscriber: Bool?
}

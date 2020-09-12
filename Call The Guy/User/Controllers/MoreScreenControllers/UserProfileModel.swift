//
//  UserProfileModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 13/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct UserProfileModelResponse : Codable{
    let UserId: Int
    let UserName: String
    let ImagePath: String?
    let Score: Int?
    let Reviews: Int?
    let Categories: String?
    let CertificatePath: String?
}

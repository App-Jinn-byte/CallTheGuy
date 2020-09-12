//
//  GetJobAppliedContractorsModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 07/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetAppliedJobContractors: Codable{
    let UserId: Int
    let UserName:String?
    let Image:String?
    let CategoryName: String?
}

//
//  ContractorsModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 10/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
struct ContractorsModelResponse: Codable {
    
    let UserId: Int
    let UserName: String?
    let Email: String?
    let CategoryId: String?
    //    let Mobile: String?
    //    let lng: String?
    //    let lat: String?
    //    let LocationCord: String?
    let ImagePath: String?
    //    let Reviews: String?
}

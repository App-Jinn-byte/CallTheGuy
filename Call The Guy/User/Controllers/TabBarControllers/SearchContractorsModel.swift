//
//  SearchContractorsModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 04/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
struct SearchContractorModel: Codable {
    
    let list:[contractorsList]
}

struct contractorsList: Codable{
    let UserId: Int
    let UserName: String?
    let Email: String?
    let CategoryName: String?
    //    let Mobile: String?
    //    let lng: String?
    //    let lat: String?
    //    let LocationCord: String?
    let ImagePath: String?
    let Reviews: Int?
    let Score: Int?
}




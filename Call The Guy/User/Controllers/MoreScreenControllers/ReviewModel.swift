//
//  ReviewModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 24/10/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
import Alamofire
struct ReviewsModelResponse: Codable {
    
    let RemarksList:[arrayList]
}

struct arrayList: Codable{
    let Remarks: remarks
    let Name: String?
}

struct remarks: Codable{
    let RatingId: Int?
    let JobId: Int?
    let CandidateId: Int?
    let IsContractor: Bool?
    let Score: Int?
    let RatedBy: Int?
    let RatedOn: String?
    let IsActive: Bool?
    let Remarks: String?
}


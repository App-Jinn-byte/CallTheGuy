//
//  JobsModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 31/12/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
struct JobsModel: Codable {
    
    let Jobs:[jobs]
}

struct jobs: Codable{
    let JobId: Int?
    let Title: String?
    let Description: String?
    let LocationName: String?
    let Fee: Int?
    let PostedDate: String?
    let CategoryName: String?
    let JobStatus: String?
    let Mobile: String?
    let AssignedTo: String?
    let JobImage: String?
    let JobStatusId: Int?
    let AssignedToId: Int?
}

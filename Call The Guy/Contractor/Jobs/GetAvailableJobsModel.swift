//
//  GetAvailableJobsModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 16/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

struct AvailableJobsForContractor: Codable{
    let JobId: Int?
    let Title: String?
    let Description: String?
    let LocationName: String?
    let Fee: Int?
    let Email: String?
    let Mobile: String?
    let PostedByName: String?
    let CategoryName: String?
    let PostedDate: String?
    let CategoryId: Int?
    let PostedBy: Int?
    let JobStatusId: Int?
    let AssignedTo: String?
    let JobImage: String?
}

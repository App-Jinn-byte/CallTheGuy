//
//  AppointmentsListModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 05/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct AppointmentsListModelResponse: Codable{
    let AppointmentsList: [appointmentsList]
}
struct appointmentsList: Codable{
    let AppointmentId: Int
    let Title: String?
    //let Type: String?
    let CreatedDate: String?
    let WithId: Int
    let Name: String?
    let Categories: String?
    let Address: String?
    let URL: String?
}

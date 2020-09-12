//
//  BlogsModel.swift
//  Call The Guy
//
//  Created by JanAhmad on 13/11/2019.
//  Copyright © 2019 jinnbyte. All rights reserved.
//

import Foundation
import Alamofire
struct BlogsModelResponse: Codable {
    
    let BlogList:[blogsList]
}

struct blogsList: Codable{
    let BlogId: Int
    let Title: String?
    let Description: String?
    let ImagePath: String?
    let ThumbNail: String
    let ToShow: String?
    let CreatedByName: String?
    let CreatedDate: String?
}




//
//  AddressComponent.swift
//  Sighted
//
//  Created by Syed M.Aurangzaib on 01/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

enum AddressType: String, Decodable {
    case street = "street_number"
    case locality
    case political
    case city = "administrative_area_level_2"
    case stateOrProvince = "administrative_area_level_1"
    case country
    case route
    case postalOrZipCode = "postal_code"
}

class AddressComponent: Decodable {
    let shortName : String
    let longName  : String
    let types     : [AddressType]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shortName   = (try? container.decode(String.self,   forKey: .shortName))  ?? String.empty
        longName    = (try? container.decode(String.self,   forKey: .longName))   ?? String.empty
        types       = (try? container.decode([AddressType].self, forKey: .types)) ?? []
    }
}

private enum CodingKeys: String, CodingKey {
    case shortName  = "short_name"
    case longName   = "long_name"
    case types
}

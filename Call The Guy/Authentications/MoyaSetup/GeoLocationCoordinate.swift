//
//  GeoLocationCoordinate.swift
//  Sighted
//
//  Created by Syed M.Aurangzaib on 01/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

class GeoLocationCoordinate: Decodable {
    
    let latitude:  Double
    let longitude: Double
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude    = (try? container.decode(Double.self, forKey: .latitude))     ?? 0.0
        longitude   = (try? container.decode(Double.self,  forKey: .longitude))   ?? 0.0
    }
}

private enum CodingKeys: String, CodingKey {
    case latitude  = "lat"
    case longitude = "lng"
}

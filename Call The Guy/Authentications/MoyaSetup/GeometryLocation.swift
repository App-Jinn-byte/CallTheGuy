//
//  GeometryLocation.swift
//  Sighted
//
//  Created by Syed M.Aurangzaib on 01/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation


class GeometryLocation: Decodable {
    
    let location : GeoLocationCoordinate?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = (try? container.decode(GeoLocationCoordinate.self, forKey: .location)) ?? nil
    }
}

private enum CodingKeys: String, CodingKey {
    case location
}

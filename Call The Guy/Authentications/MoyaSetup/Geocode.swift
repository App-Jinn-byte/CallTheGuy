//
//  Geocode.swift
//  Sighted
//
//  Created by Syed M.Aurangzaib on 01/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

class Geocode: Decodable {
    let results : [Place]
    let error   : String?
    let status  : String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = (try? container.decode([Place].self, forKey: .results)) ?? []
        error   = (try? container.decode(String.self,  forKey: .error))   ?? String.empty
        status  = (try? container.decode(String.self,  forKey: .status))  ?? String.empty
    }
}

private enum CodingKeys: String, CodingKey {
    case results
    case error = "error_message"
    case status
}

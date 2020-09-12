//
//  PlacesAutocomplete.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//
//

import Foundation

class PlacesAutocomplete: Decodable {
    let predictions : [Prediction]
    let error       : String?
    let status      : String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        predictions = (try? container.decode([Prediction].self, forKey: .predictions)) ?? []
        error       = (try? container.decode(String.self,       forKey: .error))       ?? String.empty
        status      = (try? container.decode(String.self,       forKey: .status))      ?? String.empty
    }
}

private enum CodingKeys: String, CodingKey {
    case predictions
    case error = "error_message"
    case status
}

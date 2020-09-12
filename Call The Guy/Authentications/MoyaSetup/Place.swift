//
//  Place.swift
//  Sighted
//
//  Created by Syed M.Aurangzaib on 01/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

class Place: Model, Decodable {
    let id                 : String
    let components         : [AddressComponent]
    let geometryLocation   : GeometryLocation?
    let address            : String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id          = (try? container.decode(String.self,               forKey: .id))            ?? String.empty
        components  = (try? container.decode([AddressComponent].self,   forKey: .components))    ?? []
        address     = (try? container.decode(String.self,               forKey: .address))       ?? String.empty
        geometryLocation  = (try? container.decode(GeometryLocation.self, forKey: .geometryLocation))   ?? nil
    }
    
    override var viewModel: PlaceViewModel {
        let viewModel                   = PlaceViewModel()
        viewModel.id        = id
        viewModel.address   = address
        viewModel.geometry  = self.geometryLocation
        
        for addressComponent in components {
            let types = addressComponent.types
            
            if types.contains(.street) {
                viewModel.street = addressComponent.longName
                continue
            }
            
            if types.contains(.route) {
                viewModel.route = addressComponent.longName
                continue
            }
            
            
            if types.contains(.city) {
                viewModel.city = addressComponent.longName
                continue
            }
            
            if types.contains(.stateOrProvince) {
                viewModel.stateOrProvince = addressComponent.longName
                continue
            }
            
            if types.contains(.country) {
                viewModel.countryCode = addressComponent.shortName
                viewModel.country = addressComponent.longName
                continue
            }
            
            if types.contains(.postalOrZipCode) {
                viewModel.postalOrZipCode = addressComponent.longName
            }
        }
        return viewModel
    }
}

class PlaceViewModel: ViewModel {
    var id              = String.empty
    var address         = String.empty
    var street          = String.empty
    var route           = String.empty
    var city            = String.empty
    var stateOrProvince = String.empty
    var country         = String.empty
    var countryCode     = String.empty
    var postalOrZipCode = String.empty
    var geometry:         GeometryLocation?
}


private enum CodingKeys: String, CodingKey {
    case id                = "place_id"
    case components        = "address_components"
    case address           = "formatted_address"
    case geometryLocation  = "geometry"
}

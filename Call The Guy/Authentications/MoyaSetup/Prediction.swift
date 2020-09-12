//
//  Prediction.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//
import Foundation

class Prediction: Model,Decodable {
    var id      : String
    var details : String
    
    required override init() {
        id              = String.empty
        details         = String.empty
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id      = (try? container.decode(String.self, forKey: .id))      ?? String.empty
        details = (try? container.decode(String.self, forKey: .details)) ?? String.empty
    }
    
    override var viewModel: PredictionViewModel {
        
        let predictionVM    = PredictionViewModel()
        predictionVM.id     = self.id
        predictionVM.detail = self.details
        
        return predictionVM
    }
}

private enum CodingKeys: String, CodingKey {
    case id      = "place_id"
    case details = "description"
}


class PredictionViewModel: ViewModel {
    
    var id      = String.empty
    var detail  = String.empty
}

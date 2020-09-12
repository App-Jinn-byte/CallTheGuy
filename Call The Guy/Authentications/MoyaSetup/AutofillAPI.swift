
import UIKit
import Moya

enum CreateCheckInAPI {
    case autoComplete(input: String)
    case geocode(input: String, placeId: String)
}

extension CreateCheckInAPI: TargetType {
    var baseURL: URL {
        
        switch self {
            
        case .autoComplete,.geocode:
            return googleMaps.URL!
        }
    }
    
    var path: String {
        switch self {
        case .autoComplete:
            return "/place/autocomplete/json"
        case .geocode:
            return "/geocode/json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .autoComplete:
            return .get
        case .geocode:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        
        switch self {
            
        case .autoComplete(let input):
            parameters.set(input, for: .input)
            parameters.set(googleApiKey, for: .key)
            
            return .requestParameters(parameters: parameters,encoding: URLEncoding.queryString)
            
        case .geocode(let input, let placeId):
            parameters.set(input, for: .input)
            parameters.set(placeId, for: .place_id)
            parameters.set(googleApiKey, for: .key)
            return .requestParameters(parameters: parameters,encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .autoComplete,.geocode:
            return ["Content-type": "application/json"]
        }
    }
}
extension Dictionary where Key == String {
    mutating func set(_ value: Value?, for key: DictionaryKey) {
        self[key.rawValue] = value
    }
}

enum DictionaryKey: String {
    case input
    case key
    case place_id
}

//
//  ApiResponse.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

struct APIResponsee<T: Decodable> {
    let code: String?
    let message: String?
    let total: Int?
    let totalPages: Int?
    let data: T?
}

extension APIResponsee: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code        = try?  container.decode(String.self,   forKey: .code)
        message     = try?  container.decode(String.self,   forKey: .message)
        total       = try?  container.decode(Int.self,      forKey: .total)
        totalPages  = try?  container.decode(Int.self,      forKey: .totalPages)
        data        = try?  container.decode(T.self,        forKey: .data)
    }
}
private enum CodingKeys: String, CodingKey {
    case code       = "status_code"
    case message    = "status_message"
    case total      = "total"
    case totalPages = "total_pages"
    case data
}

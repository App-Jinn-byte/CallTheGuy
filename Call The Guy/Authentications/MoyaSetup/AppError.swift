//
//  AppError.swift
//  Call The Guy
//
//  Created by JanAhmad on 15/01/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation


struct AppError {
    private var description: String
    var localizedDescription: String {
        return description
    }
    var code: Int
    
    init(description: String, code: Int = -1) {
        self.description = description
        self.code = code
    }
}


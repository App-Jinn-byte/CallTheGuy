//
//  ViewModel.swift
//  Directooo
//
//  Created by Yasir Ali on 02/04/2019.
//  Copyright © 2019 ILSA Interactive. All rights reserved.
//

import Foundation

class Model: NSObject, ViewModelable {
    
    typealias ReturnType = ViewModel
    var viewModel: ReturnType {
        fatalError("Must override")
    }
    
}

class ViewModel: NSObject {
    //    required init() {
    //    }
    //
    //    required init(model: Model) {
    //    }
    
}

class ExpandableViewModel: ViewModel {
    var title = String.empty
    var content = String.empty
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        
    }
}


class CellViewModel: ViewModel {
}


protocol ViewModelable {
    associatedtype ReturnType: ViewModel
    var viewModel: ReturnType { get }
    //    static func viewModels(from models: [Model]) -> [ReturnType]
}

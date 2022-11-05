//
//  EndPoints.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation

enum EndPoints{
    case photos
    
    var path: String{
        switch self {
        case .photos:
            return "https://jsonplaceholder.typicode.com/photos"
        }
        
    }
}

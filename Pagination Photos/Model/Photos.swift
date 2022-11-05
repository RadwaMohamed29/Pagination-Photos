//
//  Photos.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation

struct Photos: Codable{
    var array: [PhotoData]?
}

struct PhotoData: Codable{
    let albumId: Int?
    let id :Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

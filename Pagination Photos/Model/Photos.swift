//
//  Photos.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation
import SwiftUI

// MARK: - PhotosData
struct PhotosData: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias Photos = [PhotosData]

//
//  MovieData.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import Foundation
import Metal

struct MovieData: Decodable {
    let results: [Results]
    let page: Int
    let total_pages: Int // swiftlint:disable:this identifier_name
}

struct Results: Decodable {
    let poster_path: String? // swiftlint:disable:this identifier_name
    let id: Int
}

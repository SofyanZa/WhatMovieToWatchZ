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
    let total_pages: Int
}

struct Results: Decodable {
    let poster_path: String?
    let id: Int
}



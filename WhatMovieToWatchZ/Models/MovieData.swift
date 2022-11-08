//
//  Movie.swift
//  BestMovie
//
//  Created by Sofyan Zarouri on 28/09/2022.
//

import Foundation
import Metal

struct MovieData: Decodable {
    let results: [Results]
    let page: Int
    let totalPages: Int
}

struct Results: Decodable {
    let posterPath: String?
    let id: Int
}

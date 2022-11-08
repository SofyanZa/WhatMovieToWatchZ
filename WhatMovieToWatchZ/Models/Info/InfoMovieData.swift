//
//  MovieData.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import Foundation

struct InfoMovieData: Decodable {
    /// chemin de la toile de fond
    let backdrop_path: String? // swiftlint:disable:this identifier_name
    let overview: String?
    let title: String
    let release_date: String // swiftlint:disable:this identifier_name
    let vote_average: Double // swiftlint:disable:this identifier_name
    let tagline: String?
    let credits: Credits
    let videos: Videos
}

struct Credits: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let profile_path: String? // swiftlint:disable:this identifier_name
    let name: String
}

struct Videos: Decodable {
    let results: [Video]
}

struct Video: Decodable {
    let site: String
    let type: String
    let official: Bool
    let key: String
}

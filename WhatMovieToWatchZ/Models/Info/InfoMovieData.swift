//
//  MovieData.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import Foundation

struct InfoMovieData: Decodable {
    /// chemin de la toile de fond
    let backdropPath: String?
    let overview: String?
    let title: String
    let releaseDate: String
    let voteAverage: Double
    let tagline: String?
    let credits: Credits
    let videos: Videos
}

struct Credits: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let profilePath: String?
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

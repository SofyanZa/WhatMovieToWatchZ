//
//  MovieData.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import Foundation

struct InfoMovieData: Decodable {
    /// chemin de la toile de fond
    let backdrop_path: String?
    let overview: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let tagline: String?
    let credits: Credits
    let videos: Videos
}

struct Credits: Decodable{
    let cast: [Cast]
}

struct Cast: Decodable {
    let profile_path: String?
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




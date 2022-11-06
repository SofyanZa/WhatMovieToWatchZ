//
//  Movie.swift
//  BestMovie
//
//  Created by Sofyan Zarouri on 28/09/2022.
//

import Foundation

/// Modele de Données, que l'on initialise
struct Movie: Decodable {
    let posterPath: String? /// Chemin de l'image
    let adult: Bool /// Booléen section adulte
    let overview: String /// Résumé du film
    let releaseDate: String /// Date de sortie du film
    let genreIds: [Int] /// Genre du film (INT)
    let id: Int /// ID du film
    let originalTitle: String /// Titre original du film
    let originalLanguage: String /// Langue originale du film
    let title: String /// Titre original du film
    let backdropPath: String? /// URL de l'image du film
    let popularity: Double /// Popularité du film
    let voteCount: Int /// Nombre de  votes
    let video: Bool ///  Video en booléen
    let voteAverage: Double /// Moyenne de votes
    let page : Int?
    let results : [Results]

    struct Results : Decodable {
        let id : Int
        let genre_ids : [Int]
    }}


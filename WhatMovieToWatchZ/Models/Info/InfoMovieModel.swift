//
//  InfoMovieModel.swift
//  WhatMovieToWatchZ
//
//  Created by Sofyan Zarouri on 23/08/2022 
//  Copyright © 2022 Sofyan Zarouri. All rights reserved.
//

import Foundation
import UIKit

struct InfoMovieModel {
    let backdropImage: UIImage?
    let overView: String?
    let title: String
    let releaseDate: String
    let voteAverage: Double
    let tagLine: String?
    let castInfo: [CastModel]
    let videos: [Video]
}

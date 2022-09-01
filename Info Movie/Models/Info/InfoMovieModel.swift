//
//  MovieModel.swift
//  Info Movie
//
//  Created by Fábio Silva  on 23/08/2022.
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

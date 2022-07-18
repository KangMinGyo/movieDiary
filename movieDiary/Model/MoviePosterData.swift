//
//  MoviePosterData.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/17.
//

import Foundation

struct MoviePosterData : Codable {
    let results : [Results]
}

struct Results : Codable {
    let poster_path : String
}

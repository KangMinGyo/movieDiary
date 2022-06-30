//
//  MovieSearch.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/30.
//

import Foundation

struct MovieSaerch : Codable {
    let movieListResult : MovieListResult
}

struct MovieListResult : Codable {
    let movieList : [MovieList]
}

struct MovieList : Codable {
    let movieNm: String
    let prdtYear: String //개봉년도
    let nationAlt: String //제작국가
    let genreAlt: String // 장르
    
    var movieInfo: String {
        return String(nationAlt + " | " + genreAlt + " | " + prdtYear)
    }
}

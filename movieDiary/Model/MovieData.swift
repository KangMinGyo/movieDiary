//
//  MovieData.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/06/29.
//

import Foundation

struct MovieData : Codable {
    let boxOfficeResult : BoxOfficeResult
}

struct BoxOfficeResult : Codable {
    let dailyBoxOfficeList : [DailyBoxOfficeList]
}

struct DailyBoxOfficeList : Codable {
    let rank: String
    let movieNm: String
    let openDt: String
    let audiAcc: String
}

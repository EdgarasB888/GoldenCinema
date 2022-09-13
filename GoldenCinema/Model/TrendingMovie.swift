//
//  TrendingMovie.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-04.
//

import Foundation

// MARK: - TrendingMovie
struct TrendingMovie: Codable
{
    let page: Int?
    let results: [TrendingMovieInfo]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey
    {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct TrendingMovieInfo: Codable
{
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    //let originalLanguage: OriginalLanguage?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey
    {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable
{
    case en = "en"
    case ja = "ja"
    case ko = "ko"
    case te = "te"
}


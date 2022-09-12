//
//  MergedMovie.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-10.
//

import Foundation

struct MergedMovie: Codable
{
    let title: String?
    let description: String?
    let releaseDate: String?
    let category: String?
    let voteAverage: Double?
    let popularity: Double?
    let imageUrl: String?
    
    init(title: String, description: String, releaseDate: String, category: String, voteAverage: Double, popularity: Double, imageUrl: String)
    {
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
        self.category = category
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.imageUrl = imageUrl
    }
}

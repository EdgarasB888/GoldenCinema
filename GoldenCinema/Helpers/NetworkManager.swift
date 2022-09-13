//
//  NetworkManager.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-01.
//

import Foundation

class NetworkManager
{
    static var apiKey = "0275832ae7f905291b34a7492e877652"
    
    static var topMovies: [TopMovieInfo] = []
    static var trendingMovies: [TrendingMovieInfo] = []
    
    static func fetchTopMoviesData(completion: @escaping ([TopMovieInfo]) -> ())
    {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            
            guard error == nil else
            {
                print((error?.localizedDescription)!)
                return
            }
            
            guard let data = data else
            {
                print(String(describing:error))
                return
            }
            
            do
            {
                let jsonData = try JSONDecoder().decode(TopMovie.self, from: data)
                topMovies = jsonData.results ?? []
                completion (jsonData.results ?? [])
            }
            catch
            {
                print("ERRR::::", error)
            }
            
        }.resume()
    }
    
    static func fetchTrendingMoviesData(completion: @escaping ([TrendingMovieInfo]) -> ())
    {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            
            guard error == nil else
            {
                print((error?.localizedDescription)!)
                return
            }
            
            guard let data = data else
            {
                print(String(describing:error))
                return
            }
            
            do
            {
                let jsonData = try JSONDecoder().decode(TrendingMovie.self, from: data)
                trendingMovies = jsonData.results ?? []
                completion (jsonData.results ?? [])
            }
            catch
            {
                print("ERRR::::", error)
            }
            
        }.resume()
    }
}

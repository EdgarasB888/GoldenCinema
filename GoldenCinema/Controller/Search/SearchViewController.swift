//
//  SearchViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-04.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate
{
    let searchController = UISearchController()
    
    var trendingMovies: [TrendingMovieInfo] = []
    var topMovies: [TopMovieInfo] = []
    var mergedMovies: [MergedMovie] = []
    var filteredMovies = [MergedMovie]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSearchController()
        
        NetworkManager.fetchTopMoviesData { topMovies in
            self.topMovies = topMovies
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
        
        NetworkManager.fetchTrendingMoviesData { trendingMovies in
            self.trendingMovies = trendingMovies
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
        
        title = "Search"
        
        mergeMovies()
        self.tableView.reloadData()
        
        dump(topMovies)
        dump(trendingMovies)
        dump(mergedMovies)
    }
    
    func mergeMovies()
    {
        for movie in topMovies
        {
            let mergedMovie = MergedMovie(title: movie.title ?? "", releaseDate: movie.releaseDate ?? "", category: "Top Rated", voteAverage: movie.voteAverage ?? 0.0, popularity: 0.0, imageUrl: movie.backdropPath ?? "")
            mergedMovies.append(mergedMovie)
        }
        
        for movie in trendingMovies
        {
            let mergedMovie = MergedMovie(title: movie.title ?? "", releaseDate: movie.releaseDate ?? "", category: "Top Rated", voteAverage: movie.voteAverage ?? 0.0, popularity: movie.popularity ?? 0.0, imageUrl: movie.backdropPath ?? "")
            mergedMovies.append(mergedMovie)
        }
        
        dump(mergedMovies)
    }
    
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Top Rated", "Trending"]
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All")
    {
        filteredMovies = mergedMovies.filter
        {
            movie in
            let scopeMatch = (scopeButton == "All" || ((movie.category!.lowercased().contains(scopeButton.lowercased()))))
            if (searchController.searchBar.text != "")
            {
                let searchTextMatch = movie.title!.lowercased().contains(searchText.lowercased())

                return scopeMatch && searchTextMatch
            }
            else
            {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(searchController.isActive)
        {
            return filteredMovies.count
        }
        return mergedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        let item: MergedMovie!
        
        if(searchController.isActive)
        {
            item = filteredMovies[indexPath.row]
        }
        else
        {
            item = mergedMovies[indexPath.row]
        }
        
        cell.titleLabel.text = item.title
        cell.categoryLabel.text = item.category
        cell.releaseDateLabel.text = "Released: " + (item.releaseDate ?? "")
        cell.popularityLabel.text = "Popularity: " + "\(item.popularity ?? 0)"
        cell.voteAverageLabel.text = "Vote Average: " + "\(item.voteAverage ?? 0)"
        
        cell.mergedImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (item.imageUrl ?? "")))
        
        return cell
    }
    
}


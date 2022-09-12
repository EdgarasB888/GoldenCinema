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
    
    var mergedMovies: [MergedMovie] = []
    var filteredMovies = [MergedMovie]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSearchController()
        title = "Search"
        
        mergeMovies()
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
        
        dump(NetworkManager.trendingMovies)
        
        setupBarButtonMenu()
    }
    
    func mergeMovies()
    {
        for movie in NetworkManager.topMovies
        {
            let mergedMovie = MergedMovie(title: movie.title ?? "", description: movie.overview ?? "", releaseDate: movie.releaseDate ?? "", category: "Top Rated", voteAverage: movie.voteAverage ?? 0.0, popularity: 0.0, imageUrl: movie.backdropPath ?? "")
            mergedMovies.append(mergedMovie)
        }
        
        for movie in NetworkManager.trendingMovies
        {
            let mergedMovie = MergedMovie(title: movie.title ?? "", description: movie.overview ?? "", releaseDate: movie.releaseDate ?? "", category: "Trending", voteAverage: movie.voteAverage ?? 0.0, popularity: movie.popularity ?? 0.0, imageUrl: movie.backdropPath ?? "")
            mergedMovies.append(mergedMovie)
        }
    }
    
    func setupBarButtonMenu()
    {
        let barButtonMenu = UIMenu(title: "Sort by: ", children: [
            UIAction(title: NSLocalizedString("Title Ascending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.mergedMovies.sort {
                    $0.title ?? "" < $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Title Descending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.mergedMovies.sort {
                    $0.title ?? "" > $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Ascending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.mergedMovies.sort {
                    $0.releaseDate ?? "" < $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Descending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.mergedMovies.sort {
                    $0.releaseDate ?? "" > $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Ascending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.mergedMovies.sort {
                    $0.voteAverage ?? 0.0 < $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Descending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.mergedMovies.sort {
                    $0.voteAverage ?? 0.0 > $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            })
        ])
        
        navigationItem.rightBarButtonItem?.menu = barButtonMenu
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
        cell.categoryLabel.text = "Category: " + (item.category ?? "")
        cell.releaseDateLabel.text = "Released: " + (item.releaseDate ?? "")
        if(item.popularity == 0.0)
        {
            cell.popularityLabel.text = ""
        }
        else
        {
            cell.popularityLabel.text = "Popularity: " + "\(item.popularity ?? 0)"
        }
        cell.voteAverageLabel.text = "Vote Average: " + "\(item.voteAverage ?? 0)"
        
        cell.mergedImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (item.imageUrl ?? "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        let item: MergedMovie!
        item = mergedMovies[indexPath.row]
    
        vc.descriptionText = item.description
        vc.titleText = item.title
        vc.releaseDateText = item.releaseDate
        vc.voteAverageText = "\(item.voteAverage ?? 0.0)"
        vc.popularityText = "\(item.popularity ?? 0.0)"
        vc.imageUrl = "https://image.tmdb.org/t/p/original/" + (item.imageUrl ?? "")
        vc.imageToSaveUrl = "https://image.tmdb.org/t/p/original/" + (item.imageUrl ?? "")
        
        show(vc, sender: self)
    }
    
}


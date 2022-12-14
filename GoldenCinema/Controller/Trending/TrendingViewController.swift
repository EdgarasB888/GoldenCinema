//
//  TrendingViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-04.
//

import UIKit
import SDWebImage

enum selectedScope: Int
{
    case title = 0
    case releaseDate = 1
    case popularity = 2
    case voteAverage = 3
}
 
class TrendingViewController: UIViewController, UISearchBarDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width:(UIScreen.main.bounds.width), height: 70))
    
    var trendingMovies: [TrendingMovieInfo] = []
    var filteredTrendingMovies: [TrendingMovieInfo] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = "Trending"
        
        self.trendingMovies = AppDelegate.trendingMovies
        self.filteredTrendingMovies = AppDelegate.trendingMovies
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
        
        setupSearchBar()
        setupBarButtonMenu()
    }
    
    func setupBarButtonMenu()
    {
        let barButtonMenu = UIMenu(title: "Sort by: ", children: [
            UIAction(title: NSLocalizedString("Title Ascending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.title ?? "" < $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Title Descending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.title ?? "" > $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Ascending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.releaseDate ?? "" < $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Descending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.releaseDate ?? "" > $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Popularity Ascending", comment: ""), image: UIImage(systemName: "chart.line.uptrend.xyaxis"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.popularity ?? 0.0 < $1.popularity ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Popularity Descending", comment: ""), image: UIImage(systemName: "chart.line.uptrend.xyaxis"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.popularity ?? 0.0 > $1.popularity ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Ascending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.voteAverage ?? 0.0 < $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Descending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.filteredTrendingMovies.sort {
                    $0.voteAverage ?? 0.0 > $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            })
        ])
        
        navigationItem.rightBarButtonItem?.menu = barButtonMenu
    }
    
    func setupSearchBar()
    {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Title", "Release Date", "Popularity", "Vote Average"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.tintColor = UIColor(named: "NavigationColor")
        
        // User Interface is Dark
        if self.traitCollection.userInterfaceStyle == .dark
        {
            searchBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            searchBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
        // User Interface is Light
        else
        {
            searchBar.backgroundColor = UIColor(red: 241/255, green: 202/255, blue: 137/255, alpha: 1)
            searchBar.barTintColor = UIColor(red: 241/255, green: 202/255, blue: 137/255, alpha: 1)
        }
         
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        setupSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.isEmpty
        {
            NetworkManager.fetchTrendingMoviesData { trendingMovies in
                self.filteredTrendingMovies = trendingMovies
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
        else
        {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(ind: Int, text: String)
    {
        switch ind
        {
            case selectedScope.title.rawValue:
                filteredTrendingMovies = trendingMovies.filter(
                    {
                        (movie) -> Bool
                        in return movie.title?.lowercased().contains(text.lowercased()) ?? true
                    })
                self.tableView.reloadData()
            case selectedScope.releaseDate.rawValue:
                filteredTrendingMovies = trendingMovies.filter(
                    {
                        (movie) -> Bool
                        in return movie.releaseDate?.lowercased().contains(text.lowercased()) ?? true
                    })
                self.tableView.reloadData()
            case selectedScope.popularity.rawValue:
                filteredTrendingMovies = trendingMovies.filter(
                    {
                        (movie) -> Bool
                        in return "\(movie.popularity ?? 0.0)" == text
                    })
                self.tableView.reloadData()
            case selectedScope.voteAverage.rawValue:
                filteredTrendingMovies = trendingMovies.filter(
                    {
                        (movie) -> Bool
                        in return "\(movie.voteAverage ?? 0.0)" == text
                    })
                self.tableView.reloadData()
            default:
                print("No type!")
        }
    }
}

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredTrendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        let item: TrendingMovieInfo!
        item = filteredTrendingMovies[indexPath.row]
    
        vc.descriptionText = item.overview
        vc.titleText = item.title
        vc.releaseDateText = item.releaseDate
        vc.voteAverageText = "\(item.voteAverage ?? 0.0)"
        vc.popularityText = "\(item.popularity ?? 0.0)"
        vc.imageUrl = "https://image.tmdb.org/t/p/original/" + (item.posterPath ?? "")
        vc.imageToSaveUrl = "https://image.tmdb.org/t/p/original/" + (item.backdropPath ?? "")
        
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as? TrendingTableViewCell else {return UITableViewCell()}
        
        let item = filteredTrendingMovies[indexPath.row]
        
        cell.trendingTitleLabel.text = item.title
        cell.trendingReleaseDateLabel.text = "Released: " + (item.releaseDate ?? "")
        cell.trendingPopularityLabel.text = "Popularity: " + "\(item.popularity ?? 0)"
        cell.trendingVoteAverageLabel.text = "Vote Average: " + "\(item.voteAverage ?? 0)"
        cell.trendingImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (item.backdropPath ?? "")))
    
        return cell
    }
}

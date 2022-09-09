//
//  TrendingViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-04.
//

import UIKit
import SDWebImage

class TrendingViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var trendingMovies: [TrendingMovieInfo] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = "Trending"
        
        NetworkManager.fetchTrendingMoviesData { trendingMovies in
            self.trendingMovies = trendingMovies
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
        
        setupBarButtonMenu()
    }
    
    func setupBarButtonMenu()
    {
        let barButtonMenu = UIMenu(title: "Sort by: ", children: [
            UIAction(title: NSLocalizedString("Title Ascending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.trendingMovies.sort {
                    $0.title ?? "" < $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Title Descending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.trendingMovies.sort {
                    $0.title ?? "" > $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Ascending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.trendingMovies.sort {
                    $0.releaseDate ?? "" < $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Descending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.trendingMovies.sort {
                    $0.releaseDate ?? "" > $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Popularity Ascending", comment: ""), image: UIImage(systemName: "chart.line.uptrend.xyaxis"), handler: { action in
                self.trendingMovies.sort {
                    $0.popularity ?? 0.0 < $1.popularity ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Popularity Descending", comment: ""), image: UIImage(systemName: "chart.line.uptrend.xyaxis"), handler: { action in
                self.trendingMovies.sort {
                    $0.popularity ?? 0.0 > $1.popularity ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Ascending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.trendingMovies.sort {
                    $0.voteAverage ?? 0.0 < $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Descending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.trendingMovies.sort {
                    $0.voteAverage ?? 0.0 > $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            })
        ])
        
        navigationItem.rightBarButtonItem?.menu = barButtonMenu
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        let item = trendingMovies[indexPath.row]
        
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
        
        let item = trendingMovies[indexPath.row]
        
        cell.trendingTitleLabel.text = item.originalTitle
        cell.trendingReleaseDateLabel.text = "Released: " + (item.releaseDate ?? "")
        cell.trendingPopularityLabel.text = "Popularity: " + "\(item.popularity ?? 0)"
        cell.trendingVoteAverageLabel.text = "Vote Average: " + "\(item.voteAverage ?? 0)"
        cell.trendingImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (item.backdropPath ?? "")))
    
        return cell
    }
    
    
}

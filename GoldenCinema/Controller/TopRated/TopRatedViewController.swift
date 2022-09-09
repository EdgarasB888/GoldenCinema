//
//  TopRatedViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-02.
//

import UIKit
import SDWebImage

class TopRatedViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var topMovies: [TopMovieInfo] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = "Top Rated"
        
        NetworkManager.fetchTopMoviesData { topMovies in
            self.topMovies = topMovies
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
                self.topMovies.sort {
                    $0.title ?? "" < $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Title Descending", comment: ""), image: UIImage(systemName: "textformat.abc"), handler: { action in
                self.topMovies.sort {
                    $0.title ?? "" > $1.title ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Ascending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.topMovies.sort {
                    $0.releaseDate ?? "" < $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Release Date Descending", comment: ""), image: UIImage(systemName: "calendar"), handler: { action in
                self.topMovies.sort {
                    $0.releaseDate ?? "" > $1.releaseDate ?? ""
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Ascending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.topMovies.sort {
                    $0.voteAverage ?? 0.0 < $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            }),
            UIAction(title: NSLocalizedString("Vote Average Descending", comment: ""), image: UIImage(systemName: "checkmark.rectangle.portrait"), handler: { action in
                self.topMovies.sort {
                    $0.voteAverage ?? 0.0 > $1.voteAverage ?? 0.0
                }
                self.tableView.reloadData()
            })
        ])
        
        navigationItem.rightBarButtonItem?.menu = barButtonMenu
    }
}

extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("topMovies count:", topMovies.count)
        return topMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        let item = topMovies[indexPath.row]
        
        vc.descriptionText = item.overview
        vc.titleText = item.title
        vc.releaseDateText = item.releaseDate
        vc.voteAverageText = "\(item.voteAverage ?? 0.0)"
        vc.imageUrl = "https://image.tmdb.org/t/p/original/" + (item.posterPath ?? "")
        vc.imageToSaveUrl = "https://image.tmdb.org/t/p/original/" + (item.backdropPath ?? "")
        
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedTableViewCell", for: indexPath) as? TopRatedTableViewCell else {return UITableViewCell()}
        
        let item = topMovies[indexPath.row]
        
        cell.titleLabel.text = item.originalTitle
        cell.releaseDateLabel.text = "Released: " + (item.releaseDate ?? "")
        cell.voteAverageLabel.text = "Vote Average: " + "\(item.voteAverage ?? 0)"
        cell.topRatedImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (item.backdropPath ?? "")))
        
        return cell
    }
    
    
}

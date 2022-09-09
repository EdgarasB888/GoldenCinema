//
//  DetailViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-05.
//

import UIKit

class DetailViewController: UIViewController
{
    var titleText: String? = ""
    var releaseDateText: String? = ""
    var voteAverageText: String? = ""
    var popularityText: String? = ""
    var descriptionText: String? = ""
    var imageUrl: String? = ""
    var imageToSaveUrl: String? = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = titleText
        descriptionTextView.text = descriptionText
        imageView.sd_setImage(with: URL(string: imageUrl ?? ""))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        CoreDataManager.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addToSavedButtonTapped(_ sender: Any)
    {
        basicAlertSheet(title: "Attention!", message: "Movie successfully added to saved list!")
        
        let newItem = MovieItem(context: CoreDataManager.managedObjectContext!)
        newItem.title = titleText
        newItem.releaseDate = releaseDateText
        newItem.movieDescription = descriptionText
        newItem.imageUrl = imageToSaveUrl
        newItem.voteAverage = voteAverageText
    
        if(popularityText == "")
        {
            newItem.category = "Top Rated"
        }
        else
        {
            newItem.category = "Trending"
        }
        
        CoreDataManager.savedMovies.append(newItem)
        
        print("Saved movies count: ",CoreDataManager.savedMovies.count)
        
        CoreDataManager.saveData()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any)
    {
        presentShareSheet()
    }
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
         guard let dVC: WebViewController = segue.destination as? WebViewController else {return}
         
         dVC.urlString = "https://www.youtube.com/results?search_query=" + (titleText?.replacingOccurrences(of: " ", with: "+") ?? "") + "+trailer"
     }
}

extension DetailViewController
{
    private func presentShareSheet()
    {
        let shareSheetVC = UIActivityViewController(activityItems: [titleText ?? ""], applicationActivities: nil)
        
        present(shareSheetVC, animated: true)
    }
    
    private func basicAlertSheet(title: String?, message: String?)
    {
        DispatchQueue.main.async
        {
            let alertSheet: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default)
            
            alertSheet.addAction(dismissAction)
            self.present(alertSheet, animated: true)
        }
    }
}

//
//  SavedTableViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-08.
//

import UIKit
import CoreData
import SDWebImage

class SavedTableViewController: UITableViewController
{
    var savedMovies = [MovieItem]()
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = "Saved"
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        CoreDataManager.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        CoreDataManager.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        CoreDataManager.loadData()
        savedMovies = CoreDataManager.savedMovies
        tableView.reloadData()
    }
    
    
    @IBAction func filterItemsTapped(_ sender: Any)
    {
        
    }
    
    @IBAction func deleteAllSavedItems(_ sender: Any)
    {
        let actionSheetController = UIAlertController(title: "Warning!", message: "Do you really want to remove all items?", preferredStyle: .actionSheet)
        actionSheetController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            CoreDataManager.deleteAllData(entity: "MovieItem")
            CoreDataManager.loadData()
            CoreDataManager.saveData()
            self.savedMovies = CoreDataManager.savedMovies
            self.tableView.reloadData()
        }))
        
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
        present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //prideti placeholderi
        return savedMovies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTableViewCell", for: indexPath) as? SavedTableViewCell else {return UITableViewCell()}
        
        let item = savedMovies[indexPath.row]
        
        cell.categoryLabel.text = "Category: " + (item.category ?? "")
        cell.titleLabel.text = item.title
        cell.releaseDateLabel.text = "Released: " + (item.releaseDate ?? "")
        cell.voteAverageLabel.text = "Vote Average: " + "\(item.voteAverage ?? "")"
        cell.popularityLabel.text = "Popularity: " + "\(item.popularity)"
        cell.savedImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (item.imageUrl ?? "")))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                let item = CoreDataManager.savedMovies[indexPath.row]
                CoreDataManager.managedObjectContext?.delete(item)
                CoreDataManager.saveData()
                self.savedMovies = CoreDataManager.savedMovies
                tableView.reloadData()
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let itemToMove = CoreDataManager.savedMovies[sourceIndexPath.row]
            
        CoreDataManager.savedMovies.remove(at: sourceIndexPath.row)
        CoreDataManager.savedMovies.insert(itemToMove, at: destinationIndexPath.row)
            
        for(newValue, item) in CoreDataManager.savedMovies.enumerated()
        {
            item.setValue(newValue, forKey: "rowOrder")
        }
        
        self.savedMovies = CoreDataManager.savedMovies
        tableView.reloadData()
        CoreDataManager.saveData()
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        let item = savedMovies[indexPath.row]
        
        vc.descriptionText = item.movieDescription
        vc.titleText = item.title
        vc.releaseDateText = item.releaseDate
        vc.voteAverageText = item.voteAverage
        vc.popularityText = "\(item.popularity)"
        vc.imageUrl = "https://image.tmdb.org/t/p/original/" + (item.imageUrl ?? "")
        
        show(vc, sender: self)
    }
}

extension SavedTableViewController: UITableViewDragDelegate
{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension SavedTableViewController: UITableViewDropDelegate
{
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal
    {
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator)
    {
    }
}

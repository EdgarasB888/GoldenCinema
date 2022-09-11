//
//  InfoViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-11.
//

import UIKit

class InfoViewController: UIViewController
{
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.defaults.set(true, forKey: "FirstLaunch")
    }
    
    /*
    func isAppAlreadyLaunchedOnce() -> Bool
    {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce")
        {
            print("App already launched")
            return true
        }
        else
        {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
     */
    
    @IBAction func continueButtonTapped(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "InitialTabBarController") as? UITabBarController else {return}
        
        vc.modalPresentationStyle = .fullScreen
        //show(vc, sender: self)
        self.present(vc, animated: true, completion: nil)
        //present(vc, animated: true)
        //pushViewController(vc, animated: true)
        
    }
    
}

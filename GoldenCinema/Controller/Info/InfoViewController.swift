//
//  InfoViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-11.
//

import UIKit

class InfoViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if(!isAppAlreadyLaunchedOnce())
        {
            //InfoViewController.isInitial
        }
    }
    
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
}

//
//  WebViewController.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-06.
//

import UIKit
import WebKit

class WebViewController: UIViewController
{
    @IBOutlet weak var webView: WKWebView!
    var urlString = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //title = "Trailer"
        
        guard let url = URL(string: urlString) else {return}
        webView.load(URLRequest(url: url))
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

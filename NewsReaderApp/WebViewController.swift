//
//  WebViewController.swift
//  NewsReaderApp
//
//  Created by Hamid Hoseini on 10/25/17.
//  Copyright © 2017 Hamid Hoseini. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }

}

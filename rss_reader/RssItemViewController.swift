//
//  RssItemViewController.swift
//  rss_reader
//
//  Created by Alex Kukareko on 30.03.16.
//  Copyright © 2016 iit. All rights reserved.
//

import UIKit

class RssItemViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var srcUrl = ""
    var descr = ""
    var titl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        //webView.loadRequest(NSURLRequest(URL: NSURL(string: srcUrl)!))
        webView.loadHTMLString("<h1>\(titl)</h1>\(descr)", baseURL: nil)
    }
}

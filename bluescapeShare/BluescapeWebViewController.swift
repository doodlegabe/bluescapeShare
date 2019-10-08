//
//  BluescapeWebViewController.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 10/7/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit
import WebKit

class BluescapeWebViewController: UIViewController, WKNavigationDelegate {
        
    var webView: WKWebView!
    
    var bluescapeURL: URL = URL(string:"https://www.google.com")!
    
    func viewURL(){
        print("viewURL")
        webView.load(URLRequest(url: bluescapeURL))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        print("load")
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        print("didload")
        super.viewDidLoad()
        viewURL()
    }
}

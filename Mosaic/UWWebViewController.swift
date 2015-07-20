//
//  UWWebViewController.swift
//  Mosaic
//
//  Created by Ali on 2015-07-19.
//  Copyright (c) 2015 CS446. All rights reserved.
//

import Foundation

class UWWebViewController: UIViewController {
    var url: String!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "More Details";
        
        self.tabBarController?.tabBar.hidden = true
        
        var webview = UIWebView(frame:CGRectMake(0, 0, self.view.frame.width, self.view.frame.height));
        var url = NSURL(string: self.url);
        var request = NSURLRequest(URL: url!);
        webview.scalesPageToFit=true;
        webview.loadRequest(request);
        self.view.addSubview(webview);
    }
}
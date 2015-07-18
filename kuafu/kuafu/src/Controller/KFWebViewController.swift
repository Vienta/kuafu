//
//  KFWebViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/18.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    var loadUrl: String!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (self.loadUrl.isEmpty == false) {
            let url = NSURL(string: self.loadUrl)
            let urlRequest: NSURLRequest = NSURLRequest(URL: url!)
            self.webview.loadRequest(urlRequest)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    // MARK: - Private Methods
    // MARK: - Public Methods
 
    class func loadWebViewWithURL(urlString: String) -> KFWebViewController {
        let webviewViewController: KFWebViewController = KFWebViewController(nibName: "KFWebViewController", bundle: nil)
        webviewViewController.loadUrl = urlString
        return webviewViewController
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        var title: String! = webView.stringByEvaluatingJavaScriptFromString("document.title")
        self.title = title
    }
}

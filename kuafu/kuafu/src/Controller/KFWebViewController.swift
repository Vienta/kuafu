//
//  KFWebViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/18.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import NJKWebViewProgress

class KFWebViewController: UIViewController, UIWebViewDelegate, NJKWebViewProgressDelegate {

    @IBOutlet weak var webview: UIWebView!
    var loadUrl: String!
    var progressProxy: NJKWebViewProgress!
    var progressView: NJKWebViewProgressView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressProxy = NJKWebViewProgress()
        self.webview.delegate = self.progressProxy
        self.progressProxy.webViewProxyDelegate = self
        self.progressProxy.progressDelegate = self
        
        let progressBarHeight = 2.0 as CGFloat
        self.navigationController?.navigationBar.bounds
        
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.size.height
        let navigationBarWidth = self.navigationController?.navigationBar.bounds.size.width
        
        var barFrame: CGRect = CGRectMake(0, navigationBarHeight! - progressBarHeight, navigationBarWidth!, progressBarHeight)
        
        self.progressView = NJKWebViewProgressView(frame: barFrame)
        self.progressView.progressBarView.backgroundColor = KF_THEME_COLOR
        
        // Do any additional setup after loading the view.
        if (self.loadUrl.isEmpty == false) {
            let url = NSURL(string: self.loadUrl)
            let urlRequest: NSURLRequest = NSURLRequest(URL: url!)
            self.webview.loadRequest(urlRequest)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(self.progressView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressView.removeFromSuperview()
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
        self.progressView.setProgress(1.0, animated: true)
        var title: String! = webView.stringByEvaluatingJavaScriptFromString("document.title")
        self.title = title
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        println("load failure error:\(error)")
    }
    
    // MARK: - NJKWebViewProgressDelegate
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        self.progressView.setProgress(progress, animated: true)
        self.title = self.webview.stringByEvaluatingJavaScriptFromString("document.title")
    }
}

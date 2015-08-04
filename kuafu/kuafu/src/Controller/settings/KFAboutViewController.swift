//
//  KFAboutViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/18.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import JKRichTextView

class KFAboutViewController: UIViewController {
    
    @IBOutlet weak var lblCopyright: JKRichTextView!
    @IBOutlet weak var lblOpenSource: JKRichTextView!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var igvIcon: UIImageView!
    @IBOutlet weak var lblSlogan: UILabel!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "KF_SETTINGS_ABOUT_KUAFU".localized
        
        var copyright: NSString = "Design and code by Vienta in Hangzhou"
        self.lblCopyright.text = copyright as String
        self.lblCopyright.font = UIFont.systemFontOfSize(14)
        self.lblCopyright.textAlignment = .Center
        self.lblCopyright.backgroundColor = UIColor.clearColor()
        
        self.lblSlogan.text = "KF_SLOGAN".localized
        
        var copyrightRange: NSRange! = copyright.rangeOfString("Vienta")
        
        self.lblCopyright.setCustomLinkWithLinkDidTappedCallback({ url -> Bool in
            UIApplication.sharedApplication().openURL(NSURL(string: KF_MY_BLOG)!)
            return true
        }, forTextAtRange: copyrightRange)
        
        var openSource: NSString = "Open source at GitHub"
        self.lblOpenSource.text = openSource as String
        self.lblOpenSource.font = UIFont.systemFontOfSize(14)
        self.lblOpenSource.textAlignment = .Center
        self.lblOpenSource.backgroundColor = UIColor.clearColor()
        
        var openSourceRange: NSRange! = openSource.rangeOfString("GitHub")
        self.lblOpenSource.setCustomLinkWithLinkDidTappedCallback({ url -> Bool in
            self.pushToWebView(KF_PROJECT_URL)
            return true
        }, forTextAtRange: openSourceRange)
        
        self.lblVersion.text = "Version:" + APP_VERSION
        KFUtil.drawCornerView(self.igvIcon, radius: 4.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.lblCopyright.invalidateIntrinsicContentSize()
        self.lblOpenSource.invalidateIntrinsicContentSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    // MARK: - Private Methods
    
    func pushToWebView(url:String) -> Void {
        var webViewController: KFWebViewController = KFWebViewController.loadWebViewWithURL(url)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    // MARK: - Public Methods

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

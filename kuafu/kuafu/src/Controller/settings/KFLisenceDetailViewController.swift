//
//  KFLisenceDetailViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/18.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFLisenceDetailViewController: UIViewController {

    @IBOutlet weak var txvLisence: UITextView!
    var lisenceName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.lisenceName
        let lisenceFileName: String = self.lisenceName + "_LICENSE"
        let path = NSBundle.mainBundle().pathForResource(lisenceFileName, ofType: "txt")
        let lisenceContent: String! = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        self.txvLisence.text = lisenceContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

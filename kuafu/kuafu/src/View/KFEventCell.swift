//
//  KFEventCell.swift
//  kuafu
//
//  Created by Vienta on 15/6/23.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFEventCell: UITableViewCell {
    @IBOutlet weak var lblMark: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDueTime: UILabel!
    @IBOutlet weak var igvAlert: UIImageView!
    @IBOutlet weak var igvDue: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

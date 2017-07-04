//
//  TravelTableViewCell.swift
//  TaipeiTravel
//
//  Created by PeterChen on 2017/7/4.
//  Copyright © 2017年 PeterChen. All rights reserved.
//

import UIKit

class TravelTableViewCell: UITableViewCell {


    @IBOutlet weak var MRTStation: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var placeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

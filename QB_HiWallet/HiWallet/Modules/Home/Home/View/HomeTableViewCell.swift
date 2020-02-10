//
//  HomeTableViewCell.swift
//  HiWallet
//
//  Created by Jax on 2020/1/9.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var numberLabel: InsetsLabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var beginLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func setData(model:ActivityModel) {
        titleLabel.text = model.title
        descLabel.text = model.desc
        numberLabel.text = model.timeDesc
        beginLabel.text = "立即开始".localized()
        scoreLabel.text = "战绩".localized() + " " + "\(model.record)" + " " + model.unit
        bgImageView.sd_setImage(with: URL(string: model.backgroundUrl), placeholderImage: UIImage.init(named: "home_game_bg"), options: [], completed: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

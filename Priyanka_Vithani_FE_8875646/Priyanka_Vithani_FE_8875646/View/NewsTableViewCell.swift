//
//  NewsTableViewCell.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 02/12/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var fromScreenNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var newsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

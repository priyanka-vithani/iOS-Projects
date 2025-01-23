//
//  DirectionTableViewCell.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 06/12/23.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var fromScreenNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var startPoint: UILabel!
    @IBOutlet weak var endPoint: UILabel!
    @IBOutlet weak var travelMethod: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

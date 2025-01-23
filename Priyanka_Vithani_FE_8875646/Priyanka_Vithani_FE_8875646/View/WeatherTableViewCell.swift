//
//  WeatherTableViewCell.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 06/12/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var fromScreenNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

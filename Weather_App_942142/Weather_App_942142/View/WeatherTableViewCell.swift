//
//  WeatherTableViewCell.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 08/06/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherIcon: CustomImageView!
    @IBOutlet weak var temperatreLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {        
        temperatreLabel.font = .boldSystemFont(ofSize: 40)
        
        descriptionLabel.setLabel(textColor: .white, textAlignment: .center)
        feelsLikeLabel.setLabel(textColor: .white, textAlignment: .left)
        temperatreLabel.setLabel(textColor: .white, textAlignment: .left)
        locationLabel.setLabel(textColor: .white, textAlignment: .right)
        dateLabel.setLabel(textColor: .white, textAlignment: .right)
        
        weatherIcon.image = UIImage(named: "placeholderIcon")
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.backgroundColor = .clear
        weatherIcon.tintColor = .white
        
        self.setTableViewCell(cornerRadius: 15.0, bgColor: .black.withAlphaComponent(0.2))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

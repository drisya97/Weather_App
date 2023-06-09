//
//  OtherDetailsTableViewCell.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 08/06/23.
//

import UIKit

class OtherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    func configureUI() {
        humidityLabel.setLabel(textColor: .white, textAlignment: .center)
        pressureLabel.setLabel(textColor: .white, textAlignment: .center)
        windSpeedLabel.setLabel(textColor: .white, textAlignment: .center)
        
        self.setTableViewCell(cornerRadius: 15.0, bgColor: .black.withAlphaComponent(0.2))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

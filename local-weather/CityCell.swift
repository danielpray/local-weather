//
//  CityCell.swift
//  local-weather
//
//  Created by Daniel Ray on 6/30/16.
//  Copyright © 2016 Daniel Ray. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var citySearchStringLbl: UILabel!
    
    var city: City!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCityCell(city: City) {
        citySearchStringLbl.text = city.searchString
        self.city = city
    }

}

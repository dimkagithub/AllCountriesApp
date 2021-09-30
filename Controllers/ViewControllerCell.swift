//
//  ViewControllerCell.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 29.09.2021.
//

import UIKit

class ViewControllerCell: UITableViewCell {
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var countryInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

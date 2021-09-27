//
//  TableViewCell.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 25.09.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

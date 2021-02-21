//
//  ManufacturerTableCell.swift
//  Car Fleet
//
//  Created by Astha yadav on 23/01/21.
//

import UIKit

class ManufacturerTableCell: UITableViewCell {
    
    @IBOutlet weak var labelManufacturer: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.labelManufacturer.accessibilityIdentifier = "result-label"

        // Configure the view for the selected state
    }

}

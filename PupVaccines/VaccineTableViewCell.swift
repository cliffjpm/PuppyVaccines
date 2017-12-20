//
//  VaccineTableViewCell.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 11/28/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit

class VaccineTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var dogMeds: UILabel!
    @IBOutlet weak var dogMedDates: UILabel!
    @IBOutlet weak var vaccineMeds: UILabel!
    @IBOutlet weak var vaccineMedDates: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

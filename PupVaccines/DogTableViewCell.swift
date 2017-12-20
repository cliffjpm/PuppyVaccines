//
//  DogTableViewCell.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 10/20/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit

class DogTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogDOB: UILabel!
    @IBOutlet weak var dogSex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

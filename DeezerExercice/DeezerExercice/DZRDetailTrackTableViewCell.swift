//
//  DZRDetailTrackTableViewCell.swift
//  DeezerExercice
//
//  Created by AKIN on 12.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRDetailTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

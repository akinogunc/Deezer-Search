//
//  DZRTracksInfoTableViewCell.swift
//  DeezerExercice
//
//  Created by AKIN on 11.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRDetailInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }
}

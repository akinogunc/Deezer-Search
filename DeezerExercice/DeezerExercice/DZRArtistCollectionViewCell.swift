//
//  DZRArtistCollectionViewCell.swift
//  DeezerExercice
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

@objc class DZRArtistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var fans: UILabel!
    var artistIdentifier : String!

    override func awakeFromNib() {
        super.awakeFromNib()
        artistImage.layer.cornerRadius = artistImage.frame.width/2.0
        artistImage.clipsToBounds = true
        addBackgroundShadow()
    }

    func configure(model : DZRArtist){
        self.artistName.text = model.artistName
        self.fans.text = model.fans + " fans"
        self.artistIdentifier = model.artistIdentifier
        
        DZRImageCache.getImage(url: model.artistPictureUrl, completion: { (image) in
            self.artistImage.image = image
        })
    }
    
    func addBackgroundShadow(){
        self.contentView.clipsToBounds = false
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowOffset = CGSize(width: 6, height: 7)
        self.contentView.layer.shadowRadius = 2
        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: artistImage.bounds, cornerRadius: artistImage.frame.width/2).cgPath
    }
}

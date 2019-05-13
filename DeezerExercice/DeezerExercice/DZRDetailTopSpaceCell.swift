//
//  DZRAlbumHeaderTableViewCell.swift
//  DeezerExercice
//
//  Created by AKIN on 11.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRDetailTopSpaceCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
    }
    
    /*var background : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackground(){
        let view = UIView()
        view.backgroundColor = UIColor(red: 214.0/255.0, green: 217.0/255.0, blue: 236.0/255.0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.background = view
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: -500),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }*/

}

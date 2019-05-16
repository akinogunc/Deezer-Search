//
//  DZRPlayerUI.swift
//  DeezerExercice
//
//  Created by AKIN on 15.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRPlayerUI: UIView {

    @IBOutlet weak var minimizebutton: UIButton!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var elapsingTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var minimizedUI: UIView!
    @IBOutlet weak var minimizedPlay: UIButton!
    @IBOutlet weak var minimizedNext: UIButton!
    @IBOutlet weak var minimizedSongName: UILabel!
    @IBOutlet weak var minimizedArtist: UILabel!
    @IBOutlet weak var touchableArea: UIView!
    @IBOutlet weak var slider: UISlider!
    
    class func instanceFromNib() -> DZRPlayerUI {
        return UINib(nibName: "DZRPlayerUI", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DZRPlayerUI
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(album : DZRAlbum){
        
        DZRImageCache.getImage(url: album.coverPictureUrl, completion: { (image) in
            self.albumCover.image = image
            self.imageContainer.dropShadow()
        })

        albumName.text = album.albumTitle
        artistName.text = album.artistName
        minimizedArtist.text = album.albumTitle
    }
    
    func setSongName(name : String){
        songName.text = name
        minimizedSongName.text = name
    }
    
    func setPauseImages(){
        playButton.setImage(UIImage(named: "pause2.png"), for: .normal)
        minimizedPlay.setImage(UIImage(named: "pause2.png"), for: .normal)
    }
    
    func setPlayImages(){
        playButton.setImage(UIImage(named: "play2.png"), for: .normal)
        minimizedPlay.setImage(UIImage(named: "play2.png"), for: .normal)
    }
    func showMinimized(){
        minimizedUI.isHidden = false
    }
    
    func hideMinimized(){
        minimizedUI.isHidden = true
    }
}

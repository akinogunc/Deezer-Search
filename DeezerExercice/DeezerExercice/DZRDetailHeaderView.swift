//
//  d.swift
//  DeezerExercice
//
//  Created by AKIN on 11.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRDetailHeaderView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var invisibleTitle: UIView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumImageShadow: UIView!
    @IBOutlet weak var yConstraint: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tracksLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var mostPopularLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!

    var pageControl : UIPageControl?
    
    class func instanceFromNib() -> DZRDetailHeaderView {
        return UINib(nibName: "DZRDetailHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView as! DZRDetailHeaderView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        albumImage.layer.cornerRadius = 5
        albumImage.clipsToBounds = true
    }
    
    func configure(model : DZRAlbum){
        
        DZRImageCache.getImage(url: model.coverPictureUrl, completion: { (image) in
            self.albumImage.image = image
            self.albumImageShadow.dropShadow()
        })
        
        tracksLabel.text = String(model.tracks.count)
        durationLabel.text = durationFromSeconds(interval: Int(model.duration)!)
        releaseDateLabel.text = formatDate(dateString: model.releaseDate)
        fansLabel.text = model.albumFans
        albumNameLabel.text = model.albumTitle
        artistNameLabel.text = model.artistName
        mostPopularLabel.text = model.mostPopularTrack
    }
    
    func durationFromSeconds(interval : Int) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: TimeInterval(interval))!
    }
    
    func formatDate(dateString : String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy"
        let date = dateFormatterGet.date(from: dateString)
        return dateFormatterPrint.string(from: date!)
    }
}

extension DZRDetailHeaderView{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pageControl != nil{
            let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
            pageControl!.currentPage = Int(pageIndex)
        }
    }
}

extension UIView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

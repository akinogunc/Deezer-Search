//
//  DZRAlbumViewController.swift
//  DeezerExercice
//
//  Created by AKIN on 11.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetailViewModelDelegate, DZRPlayerDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var playIcon: UIImageView!
    
    var invisibleTitle           : UIView?
    var headerYConstraint        : NSLayoutConstraint?
    var oldContentOffset         : CGFloat = 0.0
    var pageControl              : UIPageControl?
    var container                : UIView?
    var viewModel                : DZRDetailViewModel!
    var headerView               : DZRDetailHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        viewModel.delegate = self
        playButton.layer.cornerRadius = 5
        DZRPlayer.singleton().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func playPauseAction(_ sender: Any) {
        if DZRPlayer.singleton().status() == .empty{
            let url = URL(fileURLWithPath: (viewModel.album?.tracks[0].previewUrl)!)
            DZRPlayer.singleton().playWithUrl(url: url)
            playIcon.image = UIImage(named: "pause.png")
            playButton.setTitle("       Pause", for: .normal)
            let indexPath = IndexPath(row: 1, section: 1)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }else if DZRPlayer.singleton().status() == .playing{
            DZRPlayer.singleton().pause()
            playIcon.image = UIImage(named: "play.png")
            playButton.setTitle("       Play", for: .normal)
        }else if DZRPlayer.singleton().status() == .paused{
            DZRPlayer.singleton().play()
            playIcon.image = UIImage(named: "pause.png")
            playButton.setTitle("       Pause", for: .normal)
        }
    }
    
    //DZRPlayer delegate function
    func playerDidFinishPlaying() {
        playIcon.image = UIImage(named: "play.png")
        playButton.setTitle("       Play", for: .normal)
        tableViewDeselectPlaying()
    }
    
    @IBAction func backAction(_ sender: Any) {
        DZRPlayer.singleton().clear()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - ViewModel delegate methods

    func dataReady() {
        DispatchQueue.main.sync {
            self.tableView.reloadData()
            if self.tableView.contentSize.height < self.view.frame.height{
                self.tableView.contentSize.height = self.view.frame.height
            }
        }
    }

    // MARK: - UITableView delegate methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 140.0
        }else if indexPath.section == 1 && indexPath.row == 0{
            return 180.0
        }else{
            return 50.0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 120.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView = DZRDetailHeaderView.instanceFromNib()
        
        //getting references from header view
        invisibleTitle = headerView.invisibleTitle
        headerYConstraint = headerView.yConstraint
        headerView.pageControl = pageControl
        container = headerView.container
        
        if viewModel.album != nil{
            headerView.configure(model: viewModel.album!)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if viewModel.album == nil{
                return 0
            }else{
                return (viewModel.album?.tracks.count)! + 1
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DZRDetailTopSpaceCell") as! DZRDetailTopSpaceCell
            return cell
            
        }else if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DZRDetailInfoTableViewCell") as! DZRDetailInfoTableViewCell
            pageControl = cell.pageControl
            
            if viewModel.album != nil{
                cell.artistName.text = viewModel.album?.artistName
                cell.albumName.text = viewModel.album?.albumTitle
            }
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DZRDetailTrackTableViewCell") as! DZRDetailTrackTableViewCell
            
            if viewModel.album != nil{
                cell.songNumberLabel.text = String(format: "%02d", indexPath.row)
                cell.songNameLabel.text = viewModel.album?.tracks[indexPath.row-1].trackTitle
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0{
            let url = URL(fileURLWithPath: (viewModel.album?.tracks[indexPath.row-1].previewUrl)!)
            DZRPlayer.singleton().playWithUrl(url: url)
            playIcon.image = UIImage(named: "pause.png")
            playButton.setTitle("       Pause", for: .normal)
        }
    }
    
    func tableViewSetup(){
        tableView.register(UINib(nibName: "DZRDetailTopSpaceCell", bundle: nil), forCellReuseIdentifier: "DZRDetailTopSpaceCell")
        tableView.register(UINib(nibName: "DZRDetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DZRDetailInfoTableViewCell")
        tableView.register(UINib(nibName: "DZRDetailTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "DZRDetailTrackTableViewCell")
    }
    
    func tableViewDeselectPlaying(){
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
}

extension DZRDetailViewController{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //alpha fade
        let delta = scrollView.contentOffset.y - self.oldContentOffset
        oldContentOffset = scrollView.contentOffset.y

        container!.alpha -= delta/60.0
        invisibleTitle?.alpha += delta/90.0

        if scrollView.contentOffset.y < 170{
            container!.alpha = 1
            invisibleTitle?.alpha = 0
        }

        //move with scrolling
        headerYConstraint!.constant = 140 - scrollView.contentOffset.y
        playButtonYConstraint!.constant = 380 - scrollView.contentOffset.y

        if scrollView.contentOffset.y < 140{
            headerYConstraint!.constant = 0
        }

        if scrollView.contentOffset.y > 280{
            playButtonYConstraint!.constant = 100
        }

    }
    
}

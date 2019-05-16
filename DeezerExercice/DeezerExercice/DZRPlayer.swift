//
//  DZRPlayer.swift
//  DeezerExercice
//
//  Created by AKIN on 13.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let DZRPlayerShared = DZRPlayer()

enum PlayerStatus{
    case playing
    case paused
    case empty
}

protocol DZRPlayerDelegate {
    func songChanged()
}

class DZRPlayer: NSObject, AVAudioPlayerDelegate, UIGestureRecognizerDelegate{
    
    var player : AVPlayer!
    var playerItem : AVPlayerItem? = nil
    var delegate: DZRPlayerDelegate?
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    let bounds = UIApplication.shared.keyWindow?.rootViewController!.view.frame.size
    let UI = DZRPlayerUI.instanceFromNib()
    var albumToPlay : DZRAlbum!
    var songIndex = 0
    var isUIShown = false
    var timer : Timer?
    var status = PlayerStatus.empty
    
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
        
    func playWithSongIndex(album : DZRAlbum, index : Int){
        
        albumToPlay = album
        songIndex = index
        UI.configure(album: albumToPlay)

        playerItem = AVPlayerItem.init(url: URL(fileURLWithPath: albumToPlay.tracks[index].previewUrl))
        player = AVPlayer(playerItem:playerItem)
        UI.playButton.setImage(UIImage(named: "pause2.png"), for: .normal)
        UI.setSongName(name: albumToPlay.tracks[index].trackTitle)
        UI.elapsingTime.text = "00:00"
        UI.remainingTime.text = String(CMTimeGetSeconds(player.currentTime()))
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)

        player.play()
        status = .playing
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        if !isUIShown{
            showUI()
        }
    }

    @objc func play(){
        if playerItem != nil{
            player.play()
            status = .playing
        }
        UI.setPauseImages()
    }
    
    func pause(){
        player.pause()
        status = .paused
        UI.setPlayImages()
    }
    
    @objc func playNext(){
        songIndex = (songIndex + 1) % albumToPlay.tracks.count
        playWithSongIndex(album : albumToPlay, index : songIndex)
        delegate?.songChanged()
    }
    
    @objc func playPrevious(){
        songIndex = (songIndex - 1)
        if songIndex < 0 {
            songIndex = albumToPlay.tracks.count - 1
        }
        playWithSongIndex(album : albumToPlay, index : songIndex)
        delegate?.songChanged()
    }
    
    func clear(){
        status = .empty
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        playNext()
    }

    @objc func updateSlider(){
        let interval = CMTimeGetSeconds(player.currentTime())
        let remaining = CMTimeGetSeconds((playerItem?.duration)! - player.currentTime())
        UI.elapsingTime.text = formatSecondsToString(interval)
        UI.remainingTime.text = "-" + formatSecondsToString(remaining)
        UI.slider.value = Float(CMTimeGetSeconds(player.currentTime())/CMTimeGetSeconds((playerItem?.duration)!))
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }

    func showUI(){
        isUIShown = true
        UI.minimizebutton.addTarget(self, action: #selector(minimizePlayer), for: .touchUpInside)
        UI.previousButton.addTarget(self, action: #selector(playPrevious), for: .touchUpInside)
        UI.playButton.addTarget(self, action: #selector(UIPlayAction), for: .touchUpInside)
        UI.minimizedPlay.addTarget(self, action: #selector(UIPlayAction), for: .touchUpInside)
        UI.nextButton.addTarget(self, action: #selector(playNext), for: .touchUpInside)
        UI.minimizedNext.addTarget(self, action: #selector(playNext), for: .touchUpInside)
        UI.frame = CGRect(x: 0, y: (rootViewController?.view.frame.height)!, width: (rootViewController?.view.frame.width)!, height: (rootViewController?.view.frame.height)!)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(maximizePlayer))
        gestureRecognizer.delegate = self
        UI.touchableArea.addGestureRecognizer(gestureRecognizer)

        rootViewController!.view.addSubview(UI)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.UI.frame = CGRect(x: 0, y: 0, width: (self.rootViewController!.view.frame.width), height: (self.rootViewController!.view.frame.height))
        })

    }
    
    @objc func UIPlayAction(){
        if status == .playing{
            pause()
        }else if status == .paused{
            play()
        }
    }
    
    @objc func minimizePlayer() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.UI.frame = CGRect(x: 0, y: self.bounds!.height, width: self.bounds!.width, height: self.bounds!.height)
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.UI.showMinimized()
                
                if self.status == .playing{
                    self.UI.setPauseImages()
                }else if self.status == .paused{
                    self.UI.setPlayImages()
                }

                self.UI.frame = CGRect(x: 0, y: self.bounds!.height - 80, width: self.bounds!.width, height: 80)
            })
        })
    }

    @objc func maximizePlayer(gestureRecognizer: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.UI.hideMinimized()
            self.UI.frame = CGRect(x: 0, y: 0, width: self.bounds!.width, height: self.bounds!.height)
            self.rootViewController?.view.bringSubviewToFront(self.UI)
        })
    }

}

extension AVPlayer {
    var isPlaying: Bool {
        return (self.rate != 0 && self.error == nil)
    }
}

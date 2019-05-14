//
//  DZRPlayer.swift
//  DeezerExercice
//
//  Created by AKIN on 13.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import Foundation
import AVFoundation

enum PlayerStatus{
    case playing
    case paused
    case empty
}

protocol DZRPlayerDelegate {
    func playerDidFinishPlaying()
}

class DZRPlayer: NSObject, AVAudioPlayerDelegate{
    
    var player : AVPlayer!
    var playerItem : AVPlayerItem? = nil
    var delegate: DZRPlayerDelegate?

    private static var sharedDZRPlayer: DZRPlayer = {
        let player = DZRPlayer()
        return player
    }()
    
    class func singleton() -> DZRPlayer {
        return sharedDZRPlayer
    }
    
    private override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func playWithUrl(url : URL){
        playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer(playerItem:playerItem)
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

    func play(){
        if playerItem != nil{
            player.play()
        }
    }
    
    func pause(){
        player.pause()
    }
    
    func clear(){
        if player != nil{
            player.pause()
        }
        playerItem = nil
    }
    
    func status() -> PlayerStatus{
        if playerItem == nil{
            return .empty
        }else if player.isPlaying{
            return .playing
        }else{
            return .paused
        }
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        clear()
        delegate?.playerDidFinishPlaying()
    }

}

extension AVPlayer {
    var isPlaying: Bool {
        return (self.rate != 0 && self.error == nil)
    }
}

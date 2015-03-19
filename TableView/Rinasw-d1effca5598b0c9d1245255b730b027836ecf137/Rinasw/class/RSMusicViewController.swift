//
//  RSMusicViewController.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/03.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreMedia

class RSMusicViewController: UIViewController, RSDialArtworkViewDelegate, RSMusicControllerDelegate{
    
    @IBOutlet var dialArtworkView : RSDialArtwrokView
    @IBOutlet var elapsedTimeLabel: UILabel
    @IBOutlet var titleArtistLabel: UILabel
    @IBOutlet var togglePlayButton: UIButton
    @IBOutlet var backTrackButton: UIButton
    @IBOutlet var forwardTrackButton: UIButton
    @IBOutlet var backgroundImageView: UIImageView
    var blurEffectView: UIVisualEffectView?

    var musicController: RSMusicRandomController?
    var player: RSMusicPlayer?
    var timer: NSTimer?
    
    var previousPlayStatus: RSMusicPlayerStatus = .None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dialArtworkView.delegate = self
        
        self.setupBackgroundView()
        self.setupMusicController()
        self.setupDisplayInfo()
        
        self.playMusic()
    }

    func setupBackgroundView() {
        self.blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        self.blurEffectView!.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        self.blurEffectView!.frame = self.backgroundImageView.bounds
        self.backgroundImageView.addSubview(self.blurEffectView)
    }
    
    func setupMusicController() {
        self.musicController = RSMusicRandomController()
        self.musicController!.delegate = self
        RSMusicControlManager.sharedManager().musicController = self.musicController
        self.player = self.musicController!.musicPlayer()
    }
    
    // MARK: Setup Info
    
    func setupDisplayInfo() {
        self.setupMusicInfo()
        self.setupArtworkInfo()
    }
    
    func setupMusicInfo() {
        if let player = self.player {
            let musicInfo = player.musicInfo
            self.titleArtistLabel.text = "\(musicInfo.title) - \(musicInfo.artist)"
        } else {
            self.titleArtistLabel.text = ""
        }
    }
    
    func updateMusicInfo() {
        if let player = self.player {
            let elapsedTime = Int(player.elapsedTime)
            let min = elapsedTime / 60
            let sec = elapsedTime % 60
            self.elapsedTimeLabel.text = String(format: "%d:%02d", min, sec)
        } else {
            self.elapsedTimeLabel.text = ""
        }
    }
    
    
    func setupArtworkInfo() {
        self.setupArtworkImage()
        self.updateArtworkViewInfo()
    }
    
    func setupArtworkImage() {
        if let player = self.player {
            let image = player.musicInfo.artworkImage
            self.dialArtworkView.artworkImage = image
            self.backgroundImageView.image = image
        }
    }
    
    func updateArtworkViewInfo() {
        if let player = self.player {
            self.dialArtworkView.duration = CGFloat(player.duration)
            self.dialArtworkView.elapsedTime = CGFloat(player.elapsedTime)
        }
    }

    
    // MARK: Play Music
    func playMusic() {
        if let player = self.player {
            player.play()
            self.togglePlayButton.selected = true
            self.startTimer()
        }
    }
    
    func pauseMusic() {
        if let player = self.player {
            player.pause()
            self.togglePlayButton.selected = false
            self.stopTimer()
        }
    }
    
    func togglePlayPause() {
        if let player = self.player {
            if player.playerStatus() == .Pause {
                self.playMusic()
            } else {
                self.pauseMusic()
            }
        }
    }
    
    func changeNextTrack() {
        if let player = self.player {
            let status = player.playerStatus()
            self.pauseMusic()
            let nextPlayer = self.musicController!.switchToNextTrack()
            if nextPlayer {
                self.player = nextPlayer
                self.setupDisplayInfo()
            } else {
                self.dismissViewController()
                return;
            }
            
            if status == .Play {
                self.playMusic()
            }
        }
    }
    
    func changePrevTrack() {
        if let player = self.player {
            let status = player.playerStatus()
            let prevPlayer = self.musicController!.switchToPrevTrack()
            if prevPlayer {
                self.pauseMusic()
                self.player = prevPlayer
                self.setupDisplayInfo()
            }
            if status == .Play {
                self.playMusic()
            }
        }
    }

    
    // MARK: Timer
    func startTimer() {
        self.stopTimer()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateElapsedTime:", userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if self.timer?.valid {
            self.timer!.invalidate()
        }
        self.timer = nil
    }
    
    func updateElapsedTime(timer: NSTimer) {
        if let player = self.player {
            self.dialArtworkView.elapsedTime = CGFloat(player.elapsedTime)
            self.updateMusicInfo()
        }
    }
    
    
    // MARK: Action
    @IBAction func touchedTogglePlayButton(sender: AnyObject) {
        self.togglePlayPause()
    }
    
    @IBAction func touchedForwardTrackButton(sender: AnyObject) {
        self.changeNextTrack()
    }
    
    @IBAction func touchedBackTrackButton(sender: AnyObject) {
        self.changePrevTrack()
    }
    
    @IBAction func touchedBackButton(sender: AnyObject) {
        self.dismissViewController()
    }
    
    @IBAction func touchedSuggestButton(sender: AnyObject) {
        self.displaySuggestMenu()
    }
    
    // MARK: Sub Menu
    
    func displaySuggestMenu() {
        let infoList = self.musicController!.randomMusicInfoListWithLimt(5) as RSMusicInfo[]
        
        let itemList = infoList.map { self.suggestMenuItemWithMusicInfo($0)}
        if itemList.count > 0 {
            let actionMenuController = RSActionMenuViewController(itemList: itemList)
            actionMenuController.presentInViewController(self,
                                        selectCallBack: { index in
                                           self.musicController!.changeTrackWithMusicInfo(infoList[index])
                                        })
        }
    }
    
    func suggestMenuItemWithMusicInfo(musicInfo: RSMusicInfo) -> RSActionMenuItem {
        let title = "\(musicInfo.title) - \(musicInfo.artist)"
        let duration = Int(musicInfo.duration)
        let min = duration / 60
        let sec = duration % 60
        let durationText = String(format: "%d:%02d", min, sec)
        let image = musicInfo.artworkImage
        let item = RSActionMenuItem(image: image, titleText: title, subText: durationText)
        return item
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.stopTimer()
    }
    
    
    // MARK: RSDialArtworkView Delegate
    func willStartChangingElapsedTimeInDialArtworkView(_: RSDialArtwrokView) {
        if let player = self.player {
            self.previousPlayStatus = player.playerStatus()
            self.stopTimer()
        }
    }
    
    func didEndChangingElapsedTimeInDialArtworkView(_: RSDialArtwrokView) {
        if (self.previousPlayStatus == .Play) {
            self.startTimer()
        }
        self.previousPlayStatus = .None
    }

    func dialArtworkView(_: RSDialArtwrokView, shouldChangeElapsedTime elapsedTime: CGFloat) -> Bool {
        if !self.player {
            return false
        }
        
        let currentTime = Double(self.player!.elapsedTime)
        let duration = Double(self.player!.duration)
        let delta = duration>0.0 ? (Double(elapsedTime)-currentTime)/duration
                                 : 0.0
        return delta < 0.01 && delta > -0.01
    }
    
    func dialArtworkView(_: RSDialArtwrokView, didChangeElapsedTime elapsedTime: CGFloat) {
        if let player = self.player {
            player.seekToTime(CDouble(elapsedTime))
            self.updateMusicInfo()
        }
    }
    
    // MARK: RSMusicController Delegate
    func updatePlayerStautsOnMusicConroller(_: RSMusicController) {
        self.setupDisplayInfo()
        self.updatePlayStatus()
    }
    
    func updatePlayStatus() {
        if let player = self.player {
            if player.playerStatus() == .Play {
                self.startTimer()
            } else {
                self.stopTimer()
            }
            self.togglePlayButton.selected = player.playerStatus() == .Play
        }
    }
}

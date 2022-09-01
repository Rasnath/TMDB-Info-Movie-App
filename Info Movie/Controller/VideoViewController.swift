//
//  VideoViewController.swift
//  Info Movie
//
//  Created by Fábio Silva  on 29/08/2022.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoViewController: UIViewController {
    
    var videoID: String?
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        if let ids = videoID {
            playerView.load(withVideoId: ids)
        } else {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
      }
  }

extension VideoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

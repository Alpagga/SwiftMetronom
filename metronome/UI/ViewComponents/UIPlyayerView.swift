import Foundation
import SwiftUI
import AVKit

class UIVideoPlayer: UIView {
    
    var playerLayer = AVPlayerLayer()
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //guard let url = URL(string: "https://github.com/bbmvicomte/videoOnboardingScreen/blob/master/bounce.mp4?raw=true") else { return }
        
        if let url = Bundle.main.url(forResource: "wallpaper", withExtension: "mp4") {
                    let player = AVPlayer(url: url)
                    player.isMuted = true
                    player.play()
                    self.player = player
                    
                    playerLayer.player = player
                    playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    
                    layer.addSublayer(playerLayer)
                    
                    // Observe when playback ends
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { [weak self] _ in
                        self?.player?.seek(to: .zero)
                        self?.player?.play()
                    }
                } else {
                    print("File not found.")
                }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

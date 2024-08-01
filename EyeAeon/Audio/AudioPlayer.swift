//
//  AudioPlayer.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/23/24.
//

import SwiftUI
import AVFoundation

struct AudioPlayer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero, url: url)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class PlayerUIView: UIView {
        private var player: AVPlayer?

        init(frame: CGRect, url: URL) {
            super.init(frame: frame)
            setupPlayer(url: url)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupPlayer(url: URL) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.bounds
            playerLayer.videoGravity = .resizeAspect
            self.layer.addSublayer(playerLayer)
            player?.play()
        }
    }
}


#Preview {
    AudioPlayer(url: Bundle.main.url(forResource: "sampleAudio", withExtension: "m4a")!)

}

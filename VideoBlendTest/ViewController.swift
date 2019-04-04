//
//  ViewController.swift
//  VideoBlendTest
//
//  Created by Andreas Hörberg on 2019-01-30.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import AVKit


class ViewController: UIViewController {

    var player: AVPlayer?
    // Add your mp4 video to the project, h.265 gives best performance
    let videoName: String = <# movie name #>
    let videoURL = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
    let imageView = UIImageView()
    override func viewDidLoad() {
        setupVideoBackground()
    }

    func setupVideoBackground() {
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        player?.actionAtItemEnd = .none
        player?.isMuted = true

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1

        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)
        playerItem.videoComposition = createVideoComposition(for: playerItem)
        player?.play()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loopVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }

    func createVideoComposition(for playerItem: AVPlayerItem) -> AVVideoComposition {
        let composition = AVVideoComposition(asset: playerItem.asset) { request in
            let inputImage = request.sourceImage

            let blendColor = CIColor(red: 1/255.0, green: 50.0/255.0, blue: 91.0/255.0)
            let multiplyColor = CIColor(red: 1/255.0, green: 50.0/255.0, blue: 91.0/255.0, alpha: 0.8)


            let blendImage = self.ciImage(from: blendColor)
            let multiplyImage = self.ciImage(from: multiplyColor)

            let colorBlend = "CIColorBlendMode"
            let multiply = "CIMultiplyBlendMode"

            let outputImage = blendImage.applyingFilter(colorBlend, parameters: [kCIInputBackgroundImageKey: inputImage
                ]).applyingFilter(multiply, parameters: [kCIInputBackgroundImageKey: multiplyImage])

            return request.finish(with: outputImage, context: nil)
        }
        return composition
    }

    func ciImage(from color: CIColor, size: CGRect = UIScreen.main.bounds) -> CIImage {
        let ciImage = CIImage(color: color)
        ciImage.cropped(to: size)
        return ciImage
    }

    @objc func loopVideo() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
}

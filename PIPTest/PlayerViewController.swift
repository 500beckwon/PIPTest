//
//  PlayerViewController.swift
//  PIPTest
//
//  Created by ByungHoon Ann on 2023/05/14.
//

import UIKit
import AVKit
import AVFoundation
// MARK: - 현재 아이폰 시뮬레이터에선 PIP 가 동작하지 않음, 아이패드는 정상 동작

final class PlayerViewController: UIViewController {
    private let playerLayer = AVPlayerLayer()
    private let player = AVPlayer()
    private var pipController: AVPictureInPictureController?
    private let button: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPip()
        buttonBasicSet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    @objc
    private func tapButton(_ sender: UIButton) {
        print(pipController, pipController?.isPictureInPictureActive)
        guard let isActive = pipController?.isPictureInPictureActive else { return }
        isActive ? pipController?.stopPictureInPicture() : pipController?.startPictureInPicture()
        isActive ? button.setTitle("비활성화", for: .normal) : button.setTitle("활성화", for: .normal)
    }
    
    func buttonBasicSet() {
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.setTitle("pip 활성화", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate(
            [
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
                button.widthAnchor.constraint(equalToConstant: 60),
                button.heightAnchor.constraint(equalToConstant: 40)
            ]
        )
    }
    
    
    private func setPip() {
        guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
        
        let asset = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: asset)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        player.play()
        
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            
            return }
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }

}


extension PlayerViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStart")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStart")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("error")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStop")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStop")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("restore")
    }
}

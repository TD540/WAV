//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 31/07/2022.
//

import AVKit
import Foundation
import MediaPlayer

class Radio: ObservableObject {
    private init() {}
    static let shared = Radio()
    let url = "https://icecast.wearevarious.com/live.mp3"
    let state = "https://icecast.wearevarious.com/status-json.xsl"
    let playerItem = AVPlayerItem(url: URL(string: "https://icecast.wearevarious.com/live.mp3")!)
    let player = AVPlayer()
    @Published var isPlaying = false
    @Published var currentShowTitle: String?

    func updateCurrentShowTitle() async {
        guard let url = URL(string: state) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let naughtyJSON = String(data: data, encoding: .utf8) {
                let fixedJSON = naughtyJSON.replacingOccurrences(of: ":-,", with: ":\"\",")
                let fixedData = fixedJSON.data(using: .utf8)!
                do {
                    let decodedIcestats = try JSONDecoder().decode(RadioState.self, from: fixedData)
                    DispatchQueue.main.async {
                        self.currentShowTitle = decodedIcestats.icestats.source.title
                    }
                } catch {
                    print("oops: \(String(describing: error))")
                }
            }
        } catch {
            print("URLSession failed \(String(describing: error))")
        }
    }

    func play() {
        player.replaceCurrentItem(with: playerItem)
        player.play()
        isPlaying = true

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            let image = UIImage(named: "artwork")!
            let artwork = MPMediaItemArtwork.init(boundsSize: image.size) { _ -> UIImage in
                image
            }
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: currentShowTitle ?? "...",
                MPMediaItemPropertyArtist: "We Are Various",
                MPMediaItemPropertyArtwork: artwork,
                MPMediaItemPropertyPlaybackDuration: 0,
                MPNowPlayingInfoPropertyIsLiveStream: true
            ]
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.playCommand.isEnabled = true
            commandCenter.stopCommand.isEnabled = true
            commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
                self?.player.play()
                self?.isPlaying = true
                return .success
            }
            commandCenter.stopCommand.addTarget  { [weak self] (event) -> MPRemoteCommandHandlerStatus in
                self?.stop()
                return .success
            }
        } catch {
            print(error.localizedDescription)
        }

    }

    func stop() {
        //player.pause()
        player.replaceCurrentItem(with: nil)
        isPlaying = false
    }

}

struct RadioState: Decodable {
    let icestats: Icestats
    struct Icestats: Decodable {
        let source: Source
        struct Source: Decodable {
            let title: String
        }
    }
}

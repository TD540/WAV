//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 31/07/2022.
//

import Foundation
import MediaPlayer

class Radio: ObservableObject {
    static let shared = Radio()

    private let state = "https://azuracast.wearevarious.com/api/nowplaying/1"
    private let playerItem = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)
    let player = AVPlayer()

    private var task: Task<Void, Error>?
    @Published var isPlaying = false
    //    @Published var isLive = false
    @Published var title: String?
    @Published var artURL: URL?

    func updateTitle() {
        task = Task(priority: .medium) {
            guard let url = URL(string: state) else { return }
            do {
                print("WAV: URLSession \(url)")
                let (data, _) = try await URLSession.shared.data(from: url)
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decoded = try jsonDecoder.decode(NowPlayingAPI.self, from: data)
                    let newTitle = decoded.nowPlaying.song.title
                    if title != newTitle {
                        DispatchQueue.main.async {
                            self.title = newTitle
                            let artURLString = decoded.nowPlaying.song.art.replacingOccurrences(of: "http:", with: "https:")
                            if artURLString != "https://azuracast.wearevarious.com/static/img/generic_song.jpg" {
                                self.artURL = URL(string: artURLString)
                            }
                        }
                    }
                } catch {
                    print("WAV: JSONDecoder", String(describing: error))
                }

            } catch {
                print("WAV: URLSession", String(describing: error))
            }
            // wait a minute
            try await Task.sleep(nanoseconds: 60_000_000_000)
            guard !Task.isCancelled else { return }
            updateTitle()
        }
    }

    func updateInfoCenter() {
        let title = title
        if let url = artURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            let artwork = MPMediaItemArtwork.init(boundsSize: image.size) { _ -> UIImage in
                                image
                            }
                            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                                MPMediaItemPropertyArtwork: artwork,
                                MPMediaItemPropertyTitle: title ?? "Radio",
                                MPMediaItemPropertyArtist: "We Are Various",
                                MPMediaItemPropertyPlaybackDuration: 0,
                                MPNowPlayingInfoPropertyIsLiveStream: true
                            ]
                        }
                    }
                }
            }
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: title ?? "Radio",
                MPMediaItemPropertyArtist: "We Are Various",
                MPMediaItemPropertyPlaybackDuration: 0,
                MPNowPlayingInfoPropertyIsLiveStream: true
            ]
        }
    }
    func play() {
        player.replaceCurrentItem(with: nil)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        isPlaying = true
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            updateInfoCenter()
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
        player.pause()
        isPlaying = false
        task?.cancel()
    }

}

struct NowPlayingAPI: Decodable {
    let nowPlaying: NowPlaying
    struct NowPlaying: Decodable {
        let song: Song
        struct Song: Decodable {
            let title: String
            let art: String
        }
    }
}

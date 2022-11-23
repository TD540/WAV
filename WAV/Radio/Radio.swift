//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 31/07/2022.
//

import Foundation
import MediaPlayer

class Radio: ObservableObject {
    private let nowPlayingURL = URL(string: "https://azuracast.wearevarious.com/api/nowplaying/1")!
    private let livestreamInfoURL = URL(string: "https://radio.wearevarious.com/stream.xml")!
    private let livestream = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)
    let player = AVPlayer()

    private var task: Task<Void, Error>?
    @Published var isPlaying = false
    @Published var isLive = false
    @Published var isOffAir = false
    @Published var title: String = "We Are Various"
    @Published var artURL: URL?

    func updateState() {
        task = Task(priority: .medium) {
            do {
                let (jsonData, _) = try await URLSession.shared.data(from: nowPlayingURL)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let newData = try jsonDecoder.decode(NowPlayingType.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.isOffAir = newData.title.lowercased().hasPrefix("currently off air")
                        self.isLive = newData.isLive
                    }
                    if title != newData.title {
                        if isLive {
                            updateLiveTitle()
                        } else {
                            updateTitle(with: newData.title)
                        }
                    }
                    if artURL != URL(string: newData.artURL) {
                        if newData.artURL.hasSuffix("generic_song.jpg") {
                            // generic artwork image available but looks aweful, so update with nil
                            updateArtURL(with: nil)
                        } else {
                            // artwork image available
                            updateArtURL(with: newData.artURL)
                        }
                    }
                } catch {
                    print("WAV: JSON decode: ", String(describing: error))
                    updateTitle(with: "We Are Various")
                    updateArtURL(with: nil)
                }
            } catch {
                print("WAV: URLSession error: ", String(describing: error))
                updateTitle(with: "We Are Various")
                updateArtURL(with: nil)
            }
            
            try await Task.sleep(nanoseconds: 60_000_000_000)
            guard !Task.isCancelled else { return }
            updateState()
        }
    }
    func updateArtURL(with newArt: String?) {
        DispatchQueue.main.async {
            if let newArt {
                self.artURL = URL(string: newArt)
            } else {
                self.artURL = nil
            }
        }
    }
    func updateTitle(with newTitle: String) {
        DispatchQueue.main.async {
            self.title = newTitle
        }
    }

    /// updateLiveTitle() parses stream.xml and updates title
    func updateLiveTitle() {
        Task(priority: .medium) {
            do {
                let (data, _) = try await URLSession.shared.data(from: livestreamInfoURL)
                let dom = MicroDOM(data: data)
                let tree = dom.parse()
                print(tree?.tag ?? "") // todo: check later if this is still "live" when wearevarious.com radio is not live
                if let tags = tree?.getElementsByTagName("title") {
                    let newTitle = tags[0].data
                    if title != newTitle {
                        updateTitle(with: newTitle)
                    }
                }
            } catch {
                print("WAV: URLSession", String(describing: error))
            }
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
                                MPMediaItemPropertyTitle: title,
                                MPMediaItemPropertyArtist: "WAV",
                                MPMediaItemPropertyPlaybackDuration: 0,
                                MPNowPlayingInfoPropertyIsLiveStream: true
                            ]
                        }
                    }
                }
            }
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: title,
                MPMediaItemPropertyArtist: "WAV",
                MPMediaItemPropertyPlaybackDuration: 0,
                MPNowPlayingInfoPropertyIsLiveStream: true
            ]
        }
    }
    func play() {
        player.replaceCurrentItem(with: nil)
        player.replaceCurrentItem(with: livestream)
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

struct NowPlayingType: Decodable {
    let nowPlaying: NowPlaying
    struct NowPlaying: Decodable {
        let song: Song
        struct Song: Decodable {
            let text: String
            let art: String
        }
    }
    var title: String {
        nowPlaying.song.text
    }
    /// `art` contains a URL string to a relevant image
    var artURL: String {
        nowPlaying.song.art.replacingOccurrences(of: "http:", with: "https:")
    }
    let live: Live
    struct Live: Decodable {
        let isLive: Bool
    }
    var isLive: Bool {
        live.isLive
    }
}

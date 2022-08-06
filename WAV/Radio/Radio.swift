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

    private let state = "https://icecast.wearevarious.com/status-json.xsl"
    private let liveState = "https://radio.wearevarious.com/stream.xml"
    private let playerItem = AVPlayerItem(url: URL(string: "https://icecast.wearevarious.com/live.mp3")!)
    let player = AVPlayer()

    private var task: Task<Void, Error>?
    @Published var isPlaying = false
    @Published var isLive = false
    @Published var title: String?

    func updateTitle() {
        task = Task(priority: .medium) {
            guard let url = URL(string: state) else { return }
            do {
                print("WAV: URLSession \(url)")
                let (data, _) = try await URLSession.shared.data(from: url)
                if let naughtyJSON = String(data: data, encoding: .utf8) {
                    let fixedJSON = naughtyJSON.replacingOccurrences(of: ":-,", with: ":\"\",")
                    let fixedData = fixedJSON.data(using: .utf8)!
                    do {
                        let decoded = try JSONDecoder().decode(RadioState.self, from: fixedData)
                        let newTitle = decoded.icestats?.source?.title
                        if title != newTitle {
                            DispatchQueue.main.async {
                                self.title = newTitle
                            }
                        }
                        if newTitle == nil {
                            updateLiveTitle()
                        }
                    } catch {
                        print("WAV: JSONDecoder", String(describing: error))
                    }
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

    func updateLiveTitle() {
        Task(priority: .medium) {
            guard let liveURL = URL(string: liveState) else { return }
            do {
                print("WAV: URLSession \(liveURL)")
                let (data, _) = try await URLSession.shared.data(from: liveURL)
                let dom = MicroDOM(data: data)
                let tree = dom.parse()
                // print(tree?.tag ?? "") // todo: check later if this is still "live" when wearevarious.com radio is not live
                if let tags = tree?.getElementsByTagName("title") {
                    let newTitle = tags[0].data
                    if title != newTitle {
                        DispatchQueue.main.async {
                            self.isLive = true
                            self.title = newTitle
                        }
                    }
                }
            } catch {
                print("WAV: URLSession", String(describing: error))
            }
        }
    }

    func cancelUpdateUnlessPlaying() {
        if !isPlaying {
            task?.cancel()
        }
    }

    func updateInfoCenter() {
        let image = isLive ? UIImage(named: "WAVIcon-live")! : UIImage(named: "WAVIcon")!
        let artwork = MPMediaItemArtwork.init(boundsSize: image.size) { _ -> UIImage in
            image
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: title ?? "Radio",
            MPMediaItemPropertyArtist: "We Are Various",
            MPMediaItemPropertyArtwork: artwork,
            MPMediaItemPropertyPlaybackDuration: 0,
            MPNowPlayingInfoPropertyIsLiveStream: true
        ]
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
    }

}

struct RadioState: Decodable {
    let icestats: Icestats?
    struct Icestats: Decodable {
        let source: Source?
        struct Source: Decodable {
            let title: String?
        }
    }
}

struct LiveRadioState: Decodable {
    let live: Live?
    struct Live: Decodable {
        let title: String?
        let location: String?
    }
}

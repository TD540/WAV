//
//  DataController.swift
//  WeAreVarious
//

import Combine
import MediaPlayer
import OSLog

class DataController: ObservableObject {
    @Published var archiveShowIsPlaying = false {
        didSet {
            // user intends to play an archive show
            Logger.check.info("WAV: archiveShowIsPlaying now \(self.archiveShowIsPlaying)")
            if archiveShowIsPlaying && radioIsPlaying {
                stopRadio()
            }
        }
    }
    @Published var selectedShow: WAVShow? {
        didSet {
            if let selectedShow {
                Logger.check.info("WAV: selected show: \(selectedShow.mixcloudURL)")
                archiveShowIsPlaying = true
            } else {
                Logger.check.info("WAV: no selected show")
            }
        }
    }
    let webViewStore = ArchiveWebViewStore()
    let wavesWebViewStore = WavesWebViewStore()
    
    // RADIO STUFF
    @Published var radioIsPlaying = false {
        didSet {
            if radioIsPlaying {
                selectedShow = nil
            }
        }
    }
    @Published var radioIsLive: Bool? // true if live, false if recording, started off false
    @Published var radioIsOffAir: Bool? // radio can be, starts off true
    @Published var radioTitle: String = "We Are Various"
    
    let radioPlayer = Player()
    let azuracastAPI = URL(string: "https://azuracast.wearevarious.com/api/nowplaying/1")!
    let livestream = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)
    
    var radioTask: Task<Void, Error>?
    
    func playArchiveShow(wavShow: WAVShow) {
        selectedShow = wavShow
    }
    
    func updateRadioMarquee() {
        Logger.check.info("WAV: Updating radio marquee...")
        radioTask?.cancel()
        
        // Todo: build better update schedule logic
        
        radioTask = Task(priority: .medium) {
            do {
                let (jsonData, _) = try await URLSession.shared.data(from: azuracastAPI)
                Logger.check.info("WAV: Radio data fetched at \(Date())")
                Logger.check.info("\(String(data: jsonData, encoding: .utf8)!)")
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let newData = try jsonDecoder.decode(AzuracastData.self, from: jsonData)
                    // Log all radio data
                    Logger.check.info("WAV: Radio data: \(String(describing: newData))")
                    DispatchQueue.main.async {
                        self.radioIsOffAir = newData.isOffAir
                        self.radioIsLive = newData.isLive
                    }
                    if radioTitle != newData.title {
                        if newData.isLive {
                            updateLiveTitle()
                        } else {
                            DispatchQueue.main.async {
                                self.radioTitle = newData.title
                                Logger.check.info("WAV: Updated RADIO title to  \(newData.title)")
                            }
                        }
                    }
                } catch {
                    Logger.check.error("Error decoding API: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.radioTitle = "We Are Various"
                    }
                }
            } catch {
                Logger.check.error("Error fetching API: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.radioTitle = "We Are Various"
                }
            }
            
            try await Task.sleep(nanoseconds: 60_000_000_000)
            guard !Task.isCancelled else { return }
            updateRadioMarquee()
        }
    }
    
    func updateLiveTitle() {
        Task(priority: .medium) {
            let url = URL(string: "https://radio.wearevarious.com/stream.xml")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let dom = MicroDOM(data: data)
                let tree = dom.parse()
                if let tags = tree?.getElementsByTagName("title") {
                    let liveTitle = tags[0].data
                    if radioTitle != liveTitle {
                        radioTitle = liveTitle
                    }
                }
                Logger.check.info("WAV: Updated LIVE title to \"\(self.radioTitle)\"")
            } catch {
                Logger.check.error("WAV: Error fetching LIVE title from \(url): \(error.localizedDescription)")
            }
        }
    }
    
    func updateInfoCenter() {
        let artwork: MPMediaItemArtwork
        let image = UIImage(named: "AppIcon")!
        artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
            image
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtwork: artwork,
            MPMediaItemPropertyTitle: radioTitle,
            MPMediaItemPropertyArtist: "We Are Various",
            MPMediaItemPropertyPlaybackDuration: 0,
            MPNowPlayingInfoPropertyIsLiveStream: true
        ]
        Logger.check.info("WAV: Updated info center")
    }
    
    func playRadio() {
        radioPlayer.replaceCurrentItem(with: nil)
        let livestream = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)
        radioPlayer.replaceCurrentItem(with: livestream)
        radioPlayer.play()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            updateInfoCenter()
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.playCommand.isEnabled = true
            commandCenter.stopCommand.isEnabled = true
            commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
                self?.radioPlayer.play()
                return .success
            }
            commandCenter.stopCommand.addTarget  { [weak self] (event) -> MPRemoteCommandHandlerStatus in
                self?.radioPlayer.pause()
                return .success
            }
        } catch {
            Logger.check.error("WAV: Error setting AVAudioSession category: \(error.localizedDescription)")
        }
        Logger.check.info("WAV: Playing WAV radio")
    }
    
    func stopRadio() {
        radioPlayer.pause()
        radioPlayer.replaceCurrentItem(with: nil)
        Logger.check.info("WAV: Stopped WAV radio")
    }
}

struct AzuracastData: Decodable {
    let nowPlaying: NowPlaying
    struct NowPlaying: Decodable {
        let song: Song
        struct Song: Decodable {
            let text: String
            let art: String
        }
    }
    var title: String {
        if nowPlaying.song.text.hasPrefix(" - ") {
            return String(nowPlaying.song.text.dropFirst(3))
        } else {
            return nowPlaying.song.text
        }
    }
    var isLive: Bool {
        title.lowercased().contains("live broadcast")
    }
    var isOffAir: Bool {
        title.lowercased().contains("currently off air")
    }
}

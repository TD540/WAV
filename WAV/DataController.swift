//
//  DataController.swift
//  WeAreVarious
//
//  Created by Thomas on 17/04/2021.
//

import Combine
import Foundation
import WebView
import WebKit
import MediaPlayer

class DataController: NSObject, ObservableObject {
    @Published var archiveShowIsPlaying = false {
        didSet {
            print("archiveShowIsPlaying changed to \(archiveShowIsPlaying)")
            archiveShowIsPlaying && radioIsPlaying ? stopRadio() : nil
        }
    }
    @Published var selectedShow: WAVShow? {
        didSet {
            if selectedShow != nil {
                archiveShowIsPlaying = true
            }
        }
    }

    // todo: consider {didSet {if selectedShow == nil {webViewStore.webView.loadHTMLString("", baseURL: nil)}}}
    // and consider removing ArchivePlayerView .onDisappear
    // as selectedShow changes, ContentView will react
    @Published var webViewStore: WebViewStore

    func playArchiveShow(wavShow: WAVShow) {
        selectedShow = wavShow
    }

    override init() {
        // WEBPLAYER STUFF
        let userContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        guard let source = try? String(
            contentsOfFile: Bundle.main.path(
                forResource: "userScript",
                ofType: "js"
            )!
        ) else {
            fatalError("userScript.js not found")
        }
        let userScript = WKUserScript(
            source: source,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false,
            in: .defaultClient
        )
        userContentController.addUserScript(userScript)
        configuration.userContentController = userContentController
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.customUserAgent = "We Are Various"
        webViewStore = WebViewStore(webView: webView)
        super.init()
    }

    // RADIO STUFF
    @Published var radioIsPlaying = false {
        didSet {
            if radioIsPlaying {
                selectedShow = nil
            }
        }
    }
    @Published var radioIsLive = false
    @Published var radioIsOffAir = true
    @Published var radioTitle: String = ""

    let radioPlayer = Player()
    let azuracastAPI = URL(string: "https://azuracast.wearevarious.com/api/nowplaying/1")!
    let livestreamAPI = URL(string: "https://radio.wearevarious.com/stream.xml")!
    let livestream = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)

    var radioTask: Task<Void, Error>?

    func updateRadioMarquee() {
        radioTask = Task(priority: .medium) {
            do {
                let (jsonData, _) = try await URLSession.shared.data(from: azuracastAPI)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let newData = try jsonDecoder.decode(AzuracastData.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.radioIsOffAir = newData.isOffAir
                        self.radioIsLive = newData.isLive
                    }
                    if radioTitle != newData.title {
                        if newData.isLive {
                            updateLiveTitle()
                        } else {
                            updateRadioTitle(with: newData.title)
                        }
                    }
                } catch {
                    updateRadioTitle(with: "We Are Various")
                }
            } catch {
                updateRadioTitle(with: "We Are Various")
            }

            try await Task.sleep(nanoseconds: 60_000_000_000)
            guard !Task.isCancelled else { return }
            updateRadioMarquee()
        }
    }

    func updateRadioTitle(with newTitle: String) {
        DispatchQueue.main.async {
            self.radioTitle = newTitle
        }
    }

    /// updateLiveTitle() parses stream.xml and updates title
    func updateLiveTitle() {
        Task(priority: .medium) {
            do {
                let livestreamAPI = URL(string: "https://radio.wearevarious.com/stream.xml")!
                let (data, _) = try await URLSession.shared.data(from: livestreamAPI)
                let dom = MicroDOM(data: data)
                let tree = dom.parse()
                if let tags = tree?.getElementsByTagName("title") {
                    let newTitle = tags[0].data
                    if radioTitle != newTitle {
                        updateRadioTitle(with: newTitle)
                    }
                }
            } catch {
                print("WAV: URLSession", String(describing: error))
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
    }

    func playRadio() {
        print("WAV: playRadio()")
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
             print(error.localizedDescription)
        }
    }
    func stopRadio() {
        radioPlayer.pause()
        radioPlayer.replaceCurrentItem(with: nil)
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

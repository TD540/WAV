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

class DataController: NSObject, ObservableObject, WKScriptMessageHandler {
    // ARCHIVE STUFF
    @Published var archiveShowIsPlaying = false {
        didSet {
            archiveShowIsPlaying && radioIsPlaying ? stopRadio() : nil
        }
    }
    @Published var selectedShow: WAVShow?
    @Published var webViewStore: WebViewStore

    func playArchiveShow(wavShow: WAVShow) {
        selectedShow = wavShow
    }
    func toggleArchiveShowPlayback() {
        webViewStore.webView.evaluateJavaScript(
            """
            (function () {
              webAudioElement.paused
              ? webAudioElement.play()
              : webAudioElement.pause()
            })()
            """,
            in: nil,
            in: .defaultClient
        )
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
        // print("WAV: \(webView.backgroundColor?.description ?? "no bgcolor")")
        webView.customUserAgent = "Mozilla/5.0 "
        + "(Windows NT 10.0; rv:78.0) "
        + "Gecko/20100101 Firefox/78.0"

        webViewStore = WebViewStore(webView: webView)

        super.init()

        userContentController.add(self, contentWorld: .defaultClient, name: "isPlaying")

    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if message.name == "isPlaying" {
            archiveShowIsPlaying = message.body as! Bool == false
        }
    }

    // RADIO STUFF
    @Published var radioIsPlaying = false {
        didSet {
            if radioIsPlaying {
                archiveShowIsPlaying ? toggleArchiveShowPlayback() : nil
                if selectedShow != nil {
                    selectedShow = nil
                }
            }
        }
    }
    @Published var radioIsLive = false
    @Published var radioIsOffAir = true
    @Published var radioTitle: String = ""
    @Published var radioArtURL: URL?

    let radioPlayer = Player()
    let azuracastAPI = URL(string: "https://azuracast.wearevarious.com/api/nowplaying/1")!
    let livestreamAPI = URL(string: "https://radio.wearevarious.com/stream.xml")!
    let livestream = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)

    private var livestreamStatusObservation: NSKeyValueObservation?

    let DEBUG_radio = true
    let DEBUG_livestream = AVPlayerItem(url: URL(string: "https://22653.live.streamtheworld.com/RADIO1_128.mp3")!)

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
                    if radioArtURL != URL(string: newData.artURL) {
                        if newData.artURL.hasSuffix("generic_song.jpg") {
                            // generic artwork image looks aweful,
                            // update with nil
                            updateRadioArtURL(with: nil)
                        } else {
                            // artwork image available
                            updateRadioArtURL(with: newData.artURL)
                        }
                        // updateArtURL(with: newData.artURL) // dev
                    }
                } catch {
                    updateRadioTitle(with: "We Are Various")
                    updateRadioArtURL(with: nil)
                }
            } catch {
                updateRadioTitle(with: "We Are Various")
                updateRadioArtURL(with: nil)
            }
            
            try await Task.sleep(nanoseconds: 60_000_000_000)
            guard !Task.isCancelled else { return }
            updateRadioMarquee()
        }
    }

    func updateRadioArtURL(with newArt: String?) {
        DispatchQueue.main.async {
            if let newArt {
                self.radioArtURL = URL(string: newArt)
            } else {
                self.radioArtURL = nil
            }
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
                let (data, _) = try await URLSession.shared.data(from: livestreamAPI)
                let dom = MicroDOM(data: data)
                let tree = dom.parse()
                // print(tree?.tag ?? "") // todo: check later if this is still "live" when wearevarious.com radio is not live
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
        if
            let url = radioArtURL,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                image
            }
        } else {
            let image = UIImage(named: "AppIcon")!
            artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                image
            }
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
        radioPlayer.replaceCurrentItem(with: nil)
        radioPlayer.replaceCurrentItem(with: DEBUG_radio ? DEBUG_livestream : livestream)
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
                self?.stopRadio()
                return .success
            }
        } catch {
            // print(error.localizedDescription)
        }
    }

    func stopRadio() {
        radioPlayer.pause()
        radioTask?.cancel()
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
        nowPlaying.song.text
    }
    /// `art` contains a URL string to a relevant image
    var artURL: String {
        nowPlaying.song.art.replacingOccurrences(of: "http:", with: "https:")
    }
    var isLive: Bool {
        title.lowercased().contains("live broadcast")
    }
    var isOffAir: Bool {
        title.lowercased().contains("currently off air")
    }
}

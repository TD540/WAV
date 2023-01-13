//
//  ArchivePlayerViewModel.swift
//  WeAreVarious
//
//  Created by Thomas on 20/05/2021.
//

import Foundation
import WebView
import WebKit
import MediaPlayer

extension ArchivePlayerView {
    class ArchivePlayerViewModel: NSObject, ObservableObject, WKScriptMessageHandler {
        let archiveDataController: ArchiveDataController

        @Published var webViewStore: WebViewStore

        init(archiveDataController: ArchiveDataController) {
            self.archiveDataController = archiveDataController
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

            if let playingRecord = archiveDataController.state.selectedShow {
                // print("WAV: Loading Widget: \(playingRecord.mixcloudWidget)")
                webViewStore.webView.load(
                    URLRequest(url: playingRecord.mixcloudWidget)
                )
            }

            userContentController.add(self, contentWorld: .defaultClient, name: "isPlaying")
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "isPlaying" {
                archiveDataController.state.isPlaying = message.body as! Bool == false
            }
        }

        func playToggle(_: Bool) {
            print("WAV: ")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
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

        func onWebViewAppearing() {
            if let selectedShow = archiveDataController.state.selectedShow {
                webViewStore.webView.load(
                    URLRequest(url: selectedShow.mixcloudWidget)
                )
            }
        }
        // Todo: selectedShowChanged is same as onWebViewAppearing
        func selectedShowChanged(selectedShow: WAVShow?) {
            if let selectedShow = selectedShow {
                webViewStore.webView.load(
                    URLRequest(url: selectedShow.mixcloudWidget)
                )
            }
        }

//        func updatecommandCenter(isPlaying: Bool) {
//            guard let selectedShow = archiveDataController.state.selectedShow else { return }
//            guard isPlaying else { return }
//            updateInfoCenter(with: selectedShow)
//            return
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback)
//                try AVAudioSession.sharedInstance().setActive(true)
//                let commandCenter = MPRemoteCommandCenter.shared()
//                commandCenter.playCommand.isEnabled = true
//                commandCenter.pauseCommand.isEnabled = true
//                commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
//                    self?.playToggle()
//                    print("WAV: commandCenter pause")
//                    return .success
//                }
//                commandCenter.pauseCommand.addTarget  { [weak self] (event) -> MPRemoteCommandHandlerStatus in
//                    self?.playToggle()
//                    print("WAV: commandCenter play")
//                    return .success
//                }
//            } catch {
//                print("WAV: selectedShowChanged \(error.localizedDescription)")
//            }
//        }

//        func updateInfoCenter(with selectedShow: WAVShow) {
//            DispatchQueue.global().async {
//                print("WAV: global async updateInfoCenter: \(selectedShow.title.rendered)")
//                if let data = try? Data(contentsOf: selectedShow.pictureURL) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            print("WAV: main async nowPlayingInfo: \(selectedShow.title.rendered)")
//                            let artwork = MPMediaItemArtwork.init(boundsSize: image.size) { _ -> UIImage in
//                                image
//                            }
//                            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
//                                MPMediaItemPropertyArtwork: artwork,
//                                MPMediaItemPropertyTitle: selectedShow.title.rendered,
//                                MPMediaItemPropertyArtist: "We Are Various"
//                                // MPMediaItemPropertyPlaybackDuration: 0
//                            ]
//                        }
//                    }
//                }
//            }
//        }

    }
}

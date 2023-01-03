//
//  ArchivePlayerViewModel.swift
//  WeAreVarious
//
//  Created by Thomas on 20/05/2021.
//

import Foundation
import WebView
import WebKit

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
            webView.customUserAgent = "Mozilla/5.0 "
            + "(Windows NT 10.0; rv:78.0) "
            + "Gecko/20100101 Firefox/78.0"

            webViewStore = WebViewStore(webView: webView)

            super.init()

            if let playingRecord = archiveDataController.state.selectedPost {
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

        func playToggle() {
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
            if let selectedPost = archiveDataController.state.selectedPost {
                webViewStore.webView.load(
                    URLRequest(url: selectedPost.mixcloudWidget)
                )
            }
        }

        func onPlayingRecordChanging(playingRecord: WAVPost?) {
            if let playingRecord = playingRecord {
                webViewStore.webView.load(
                    URLRequest(url: playingRecord.mixcloudWidget)
                )
            }
        }
    }
}

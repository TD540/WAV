//
//  WebPlayerViewModel.swift
//  WeAreVarious
//
//  Created by Thomas on 20/05/2021.
//

import Foundation
import WebView
import WebKit

extension WebPlayerView {
    class ViewModel: NSObject, ObservableObject, WKScriptMessageHandler {
        let dataController: DataController
        var playingRecord: MixcloudCast? { dataController.state.playing }

        @Published var webViewStore: WebViewStore
        @Published var isPlaying = false

        init(dataController: DataController) {
            self.dataController = dataController
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

            if let playingRecord = playingRecord {
                webViewStore.webView.load(
                    URLRequest(url: playingRecord.webPlayerURL)
                )
            }

            userContentController.add(self, contentWorld: .defaultClient, name: "isPlaying")
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            if message.name == "isPlaying" {
                // swiftlint:disable:next force_cast
                isPlaying = message.body as! Bool == false // 😅
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
            if let playingRecord = playingRecord {
                webViewStore.webView.load(
                    URLRequest(url: playingRecord.webPlayerURL)
                )
            }
        }

        func onPlayingRecordChanging(playingRecord: MixcloudCast?) {
            if let playingRecord = playingRecord {
                webViewStore.webView.load(
                    URLRequest(url: playingRecord.webPlayerURL)
                )
            }
        }
    }
}

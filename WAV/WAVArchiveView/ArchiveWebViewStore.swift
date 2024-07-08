//
//  ArchiveWebViewStore.swift
//  WAV
//

import Foundation
import WebKit
import OSLog

class ArchiveWebViewStore: WebViewStore {
    init() {
        super.init()
        let userContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        do {
            guard let scriptPath = Bundle.main.path(forResource: "userScript", ofType: "js") else {
                throw NSError(domain: "DataControllerError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Path for userScript.js not found"])
            }
            let source = try String(contentsOfFile: scriptPath)
            let userScript = WKUserScript(
                source: source,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: false
            )
            userContentController.addUserScript(userScript)
        } catch {
            Logger.check.error("WAV: Failed to load userScript.js with error: \(error.localizedDescription)")
        }

        configuration.userContentController = userContentController
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.customUserAgent = "We Are Various"

        self.webView = webView
    }
}


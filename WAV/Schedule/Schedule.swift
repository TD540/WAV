//
//  WeekSchedule.swift
//  WAV
//
//  Created by Thomas on 08/10/2022.
//

import SwiftUI
import WebKit

struct Schedule: View {
    @StateObject var webViewStore: WebViewStore
    init() {
        /// Some CSS to hide everything but page content
        let css = "body > :not(.box-wrapper), .menu-wrapper, .main-container > :not(.page-wrapper), #page-header {display: none !important}"
        let source = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style)"
        let userScript = WKUserScript(
            source: source,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .defaultClient
        )
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        let store = WebViewStore(webView: WKWebView(frame: .zero, configuration: configuration))
        _webViewStore = StateObject(wrappedValue: store)
    }
    var body: some View {
        WebView(webView: webViewStore.webView)
            .onAppear {
                webViewStore.webView.load(URLRequest(url: URL(string: "https://wearevarious.com/week-schedule")!))
            }
    }
}

struct WeekSchedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule()
    }
}

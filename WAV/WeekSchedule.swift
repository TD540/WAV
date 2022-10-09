//
//  WeekSchedule.swift
//  WAV
//
//  Created by Thomas on 08/10/2022.
//

import SwiftUI
import WebView
import WebKit

struct WeekSchedule: View {
    @StateObject var webViewStore: WebViewStore
    let url = "https://wearevarious.com/week-schedule"
    var body: some View {
        WebView(webView: webViewStore.webView)
            .onAppear {
                webViewStore.webView.load(
                    URLRequest(
                        url: URL(string: url)!
                    )
                )
            }
    }
    init() {
        /// Some CSS to hide everything but page content
        let css = """
                  body > :not(.box-wrapper),
                  .menu-wrapper,
                  .main-container > :not(.page-wrapper),
                  #page-header {
                    display: none !important
                  }
                  """
        let js = """
                 var style = document.createElement('style')
                 style.innerHTML = '\(css)'
                 document.head.appendChild(style)
                 """
        let script = WKUserScript(
            source: js,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .defaultClient
        )
        let controller = WKUserContentController()
        controller.addUserScript(script)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller
        let store = WebViewStore(
            webView: WKWebView(
                frame: .zero,
                configuration: configuration
            )
        )
        _webViewStore = StateObject(wrappedValue: store)
    }
}

struct WeekSchedule_Previews: PreviewProvider {
    static var previews: some View {
        WeekSchedule()
    }
}

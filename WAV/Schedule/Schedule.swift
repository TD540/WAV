//
//  WeekSchedule.swift
//  WAV
//
//  Created by Thomas on 08/10/2022.
//

import SwiftUI
import WebView
import WebKit

struct Schedule: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var webViewStore: WebViewStore

    init() {
        let css = """
            *{background-color: transparent!important}
        body > :not(.box-wrapper), .menu-wrapper, .main-container > :not(.page-wrapper), #page-header {display: none !important} .main-container .row-container .row-parent { padding: 16px 36px }
        """
        let appendStyle = "var style = document.createElement('style'); style.innerHTML = `\(css)`; document.head.appendChild(style)"
        let userScript = WKUserScript(
            source: appendStyle,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .world(name: "app")
        )
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        let store = WebViewStore(webView: WKWebView(frame: .zero, configuration: configuration))

        store.webView.isOpaque = false
        store.webView.backgroundColor = .clear
        store.webView.scrollView.backgroundColor = .clear

        _webViewStore = StateObject(wrappedValue: store)
    }

    var body: some View {
        ZStack(alignment: Alignment.top) {
            //                .frame(maxHeight: 200)
            //                .blur(radius: 4)
            WebView(webView: webViewStore.webView)
                .padding(.top, -70)
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    webViewStore.webView.load(URLRequest(url: URL(string: "https://wearevarious.com/week-schedule")!))
                }
        }
    }

}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule()
    }
}
